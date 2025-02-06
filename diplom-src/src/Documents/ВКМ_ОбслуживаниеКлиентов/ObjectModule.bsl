#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ОбработчикиСобытий
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаЧасовКОплатеКлиенту = ВыполненныеРаботы.Итог("ЧасыКОплатеКлиенту");
	
	Если Не ЭтоНовый() Тогда 
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_ОбслуживаниеКлиентов.Дата КАК Дата,
	|	ВКМ_ОбслуживаниеКлиентов.Специалист КАК Специалист,
	|	ВКМ_ОбслуживаниеКлиентов.ВремяНачалаРабот КАК ВремяНачалаРабот,
	|	ВКМ_ОбслуживаниеКлиентов.ВремяОкончанияРабот КАК ВремяОкончанияРабот,
	|	ВКМ_ОбслуживаниеКлиентов.Специалист.Представление КАК СпециалистПредставление,
	|	ВКМ_ОбслуживаниеКлиентов.ОписаниеПроблемы КАК ОписаниеПроблемы,
	|	ВКМ_ОбслуживаниеКлиентов.Номер КАК Номер
	|ИЗ
	|	Документ.ВКМ_ОбслуживаниеКлиентов КАК ВКМ_ОбслуживаниеКлиентов
	|ГДЕ
	|	ВКМ_ОбслуживаниеКлиентов.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ТекстСообщенияНачальный = СтрШаблон("Изменен документ обслуживани клиентов № %1. Специалист: %2. Задача: %3. ", Выборка.Номер, Выборка.СпециалистПредставление, Выборка.ОписаниеПроблемы );
		ТекстИзменений = "";
		Если Дата <> Выборка.Дата Тогда
			ТекстИзменений = СтрШаблон("Изменена дата документа. Старая дата :%1, новая дата: %2. ", Выборка.Дата, Дата);
		КонецЕсли;
		Если ВремяНачалаРабот <> Выборка.ВремяНачалаРабот Тогда
			ТекстИзменений = ТекстИзменений + СтрШаблон("Изменено время начала работ. Новое время начала работ: %1. ", Формат(ВремяНачалаРабот, "ДЛФ=ДД"));
		КонецЕсли;
		Если ВремяОкончанияРабот <> Выборка.ВремяОкончанияРабот Тогда
			ТекстИзменений = ТекстИзменений + СтрШаблон("Изменено время окончания работ. Новое время окончания работ: %1. ", Формат(ВремяОкончанияРабот, "ДЛФ=ДД"));
		КонецЕсли;
		Если Специалист <> Выборка.Специалист Тогда
			ТекстИзменений = ТекстИзменений + СтрШаблон("Назначен новый специалист: %1. ", Специалист);
		КонецЕсли;
		Если ОписаниеПроблемы <> Выборка.ОписаниеПроблемы Тогда
			ТекстИзменений = ТекстИзменений + СтрШаблон("Новое описание задачи: %1. " , ОписаниеПроблемы);
			
		КонецЕсли;
		ТекстСообщенияКонечный = ТекстСообщенияНачальный + ТекстИзменений;
		Если ТекстСообщенияКонечный <> ТекстСообщенияНачальный Тогда	
		НовоеУведомление = Справочники.ВКМ_УведомленияТелеграмБотуДляОтправки.СоздатьЭлемент();
		НовоеУведомление.ТекстСообщения = ТекстСообщенияКонечный;
		НовоеУведомление.Записать();	
		КонецЕсли;
		 
	КонецЕсли;
	Иначе 
		ТекстСообщения = СтрШаблон("Создан документ обслуживание клиентов №%1. Специалист: %2. Время начала работ: %3. Время окончания работ %4. Задача: %5.", 
		        Номер, Специалист, Формат(ВремяНачалаРабот, "ДЛФ=ДД"), Формат(ВремяОкончанияРабот, "ДЛФ=ДД"),ОписаниеПроблемы); 
		НовоеУведомление = Справочники.ВКМ_УведомленияТелеграмБотуДляОтправки.СоздатьЭлемент();
		НовоеУведомление.ТекстСообщения = ТекстСообщения;
		НовоеУведомление.Записать();	     
			     
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	
	
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "ВидДоговора, ВКМ_ДатаНачалаДействияДоговора, ВКМ_ДатаОкончанияДействияДоговора, ВКМ_СтоимостьЧасаРаботы");
	Если РеквизитыДоговора.ВидДоговора <> Перечисления.ВидыДоговоровКонтрагентов.ВКМ_АбонетскоеОбслуживание Тогда
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Вид договора %1 не является абонентским", РеквизитыДоговора.ВидДоговора));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Если РеквизитыДоговора.ВКМ_ДатаНачалаДействияДоговора > Дата Тогда
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Дата начала действия договора: %1, больше текущей даты: %2 ", РеквизитыДоговора.ВКМ_ДатаНачалаДействияДоговора, Дата));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Если РеквизитыДоговора.ВКМ_ДатаОкончанияДействияДоговора < Дата Тогда
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Договор закрыт. Дата окончания действия договора: %1.", РеквизитыДоговора.ВКМ_ДатаОкончанияДействияДоговора));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ВыполненныеРаботы.Количество() > 0 Тогда
	// регистр ВКМ_РаботыВыполненныеКлиенту
	Движения.ВКМ_РаботыВыполненныеКлиенту.Записывать = Истина;
	Движение = Движения.ВКМ_РаботыВыполненныеКлиенту.Добавить();
	Движение.Период = Дата;
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Клиент = Клиент;
	Движение.Договор = Договор;
	Движение.КоличествоЧасов = СуммаЧасовКОплатеКлиенту;
	Движение.СуммаКОплате = СуммаЧасовКОплатеКлиенту*РеквизитыДоговора.ВКМ_СтоимостьЧасаРаботы;
	
	
	ВидВыплаты = "ПроцентОтРабот";
	ПроцентОплатыСпециалиста = ВКМ_РасчетыИНачисления.ПолучитьТекущееЗначениеВыплаты(Специалист,Дата, ВидВыплаты);
	
	Если ПроцентОплатыСпециалиста = Неопределено Тогда
	    ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Процент оплаты специалиста %1 на текущую дату не заполнен", Специалист));
        Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ДолжностьСпециалист = ВКМ_РасчетыИНачисления.ПроверитьДолжностьСотрудника(Специалист);
	
	Если ДолжностьСпециалист Тогда	
	//регистр ВКМ_РаботыВыполненныеСотрудником
	Движения.ВКМ_РаботыВыполненныеСотрудником.Записывать = Истина;
	Движение = Движения.ВКМ_РаботыВыполненныеСотрудником.Добавить();
	Движение.Период = Дата;
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Сотрудник = Специалист; 
	Движение.КоличествоЧасов = СуммаЧасовКОплатеКлиенту;
	Движение.СуммаКОплате = СуммаЧасовКОплатеКлиенту*РеквизитыДоговора.ВКМ_СтоимостьЧасаРаботы*ПроцентОплатыСпециалиста/100;
	КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
	
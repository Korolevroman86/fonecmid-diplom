

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры


Процедура ОбработкаПроведения(Отказ,Режим)
	
	Движения.ВКМ_ПринятыеУволенныеСотрудники.Записывать = Истина;

	
	Для Каждого СтрокаСотрудники Из Сотрудники Цикл
		
		СтатусСотрудника = ВКМ_РасчетыИНачисления.ПроверкаСтатусаСотрудника(СтрокаСотрудники.Сотрудник, Дата);
		Если СтатусСотрудника Тогда
			Движение = Движения.ВКМ_ПринятыеУволенныеСотрудники.Добавить();
			Движение.Сотрудник = СтрокаСотрудники.Сотрудник;
			Движение.ПринятУволен = Ложь;
			Движение.Период = Дата;
			Движение.Регистратор = Ссылка;
		
		КонецЕсли;
				
		
	КонецЦикла;

	
КонецПроцедуры

#КонецОбласти



#КонецЕсли


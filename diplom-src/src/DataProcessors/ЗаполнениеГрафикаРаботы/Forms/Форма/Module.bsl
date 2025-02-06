#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Заполнить(Команда)
	Если Не ЗначениеЗаполнено(Объект.Период) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Необходимо заполнить период");
		Возврат
	КонецЕсли;
	
	ЗаполнитьНаСервере(Объект.Период);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции
&НаСервереБезКонтекста
Процедура ЗаполнитьНаСервере(Период)
	ДатаПериода = Период.ДатаНачала;
	Пока ДатаПериода < Период.ДатаОкончания Цикл 
		Запись = РегистрыСведений.ВКМ_ГрафикРаботы.СоздатьМенеджерЗаписи();
		Запись.Дата =  ДатаПериода;
		Если ДеньНедели(ДатаПериода) <= 5 Тогда
			Запись.Значение = 1;
		КонецЕсли;
		Запись.Записать();
		ДатаПериода = ДатаПериода + 86400;	
	КонецЦикла;	

КонецПроцедуры


#КонецОбласти
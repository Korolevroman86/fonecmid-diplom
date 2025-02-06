#Область ПрограммныйИнтерфейс

//Определяет имя формы и вызывает соответвующую процедуру для добавления полей на форму
//Параметры:
//Форма - ФормаКлиентскогоПриложения
Процедура ДобавлениеРеквизитовНаФорму(Форма) Экспорт;

	ИмяФормы = Форма.ИмяФормы;
	
	Если ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента" Тогда  
		
		ДобавитьПолеНаФорму(Форма);
		
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//Добавляет поле на форму
//Параметры:
//Форма - ФормаКлиентскогоПриложения
Процедура ДобавитьПолеНаФорму(Форма)
	
	КоманднаяПанель = Форма.КоманднаяПанель;
	Группа = Форма.Элементы.Добавить("Команды", Тип("ГруппаФормы"), КоманднаяПанель);
	
	Кнопка = Форма.Элементы.Добавить("ВКМ_Заполнить", Тип("КнопкаФормы"), Группа);
	Кнопка.ИмяКоманды = "ВКМ_Заполнить";

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыОтпускаСотрудников

&НаКлиенте
Процедура ОтпускаСотрудниковДатаНачалаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Элементы.ОтпускаСотрудников.ТекущиеДанные.ДатаОкончания) Тогда
		ПересчитатьКоличествоДнейОтпуска(Элементы.ОтпускаСотрудников.ТекущиеДанные);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПересчитатьКоличествоДнейОтпуска(ДанныеСтроки)
	
	//
	

КонецПроцедуры

#КонецОбласти

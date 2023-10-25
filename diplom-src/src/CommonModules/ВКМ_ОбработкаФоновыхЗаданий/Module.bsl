
#Область СлужебныеПроцедурыИФункции

Функция ФоновоеЗаданиеАктивно(НаименованиеЗадания) Экспорт 
	Результат = Ложь;
	
	Отбор = Новый Структура("Наименование, Состояние", 
					НаименованиеЗадания, 
					СостояниеФоновогоЗадания.Активно);  
	ПолученныеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если ПолученныеЗадания.Количество() > 0 Тогда 
		Результат = Истина;
	КонецЕсли;    
	
    Возврат Результат;
КонецФункции

Функция АбонентскиеДоговорыЗаПериод(НачалоОтбора, КонецОтбора) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.ВКМ_АбонентскоеОбслуживание)
	|	И ДоговорыКонтрагентов.ВКМ_ДатаНачалаДействия < &КонецОтбора
	|	И ДоговорыКонтрагентов.ВКМ_ДатаОкончанияДействия > &НачалоОтбора";
	
	Запрос.УстановитьПараметр("НачалоОтбора", НачалоОтбора);
	Запрос.УстановитьПараметр("КонецОтбора", КонецОтбора);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат Выборка;
	КонецЕсли;

КонецФункции

Функция СозданиеРеализацийПоДоговорам(МассивДоговоров) Экспорт
	
	МассивВозврата = Новый Массив;
	Для Каждого ЭлементМассива Из МассивДоговоров Цикл
		Структура = Новый Структура;
		Структура.Вставить("Договор", ЭлементМассива);
		НоваяРеализация = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
		НоваяРеализация.Заполнить(ЭлементМассива);
		НоваяРеализация.ВыполнитьАвтозаполнение();
		Если НоваяРеализация.ПроверитьЗаполнение() Тогда
			НоваяРеализация.Записать(РежимЗаписиДокумента.Проведение);
			Структура.Вставить("Реализация", НоваяРеализация.Ссылка);
		КонецЕсли;
		МассивВозврата.Добавить(Структура);
	КонецЦикла;
	
	Возврат МассивВозврата;

КонецФункции

#КонецОбласти

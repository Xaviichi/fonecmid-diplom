
#Если Сервер Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция СформироватьВзаиморасчеты(Документ) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(ЕСТЬNULL(ОсновныеНачисления.Сумма, 0)) КАК ОсновныеНачисления,
	               |	СУММА(ЕСТЬNULL(ДополнительныеНачисления.Сумма, 0)) КАК ДополнительныеНачисления,
	               |	СУММА(ЕСТЬNULL(Удержания.Сумма, 0)) КАК Удержания
	               |ИЗ
	               |	РегистрРасчета.ОсновныеНачисления КАК ОсновныеНачисления,
	               |	РегистрРасчета.ДополнительныеНачисления КАК ДополнительныеНачисления,
	               |	РегистрРасчета.Удержания КАК Удержания
	               |ГДЕ
	               |	ОсновныеНачисления.Регистратор = &Регистратор
	               |	И ДополнительныеНачисления.Регистратор = &Регистратор
	               |	И Удержания.Регистратор = &Регистратор";
	
	Запрос.УстановитьПараметр("Регистратор", Документ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Возврат 0;
	Иначе
		Выборка.Следующий();
		Взаиморасчеты = Выборка.ОсновныеНачисления + Выборка.ДополнительныеНачисления - Выборка.Удержания;
		Возврат Взаиморасчеты;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьВзаиморасчеты(ДатаЗаполнения) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.Сотрудник,
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.СуммаОстаток
	|ИЗ
	|	РегистрНакопления.ВКМ_ВзаиморасчетыССотрудниками.Остатки(&ДатаЗаполнения,) КАК ВКМ_ВзаиморасчетыССотрудникамиОстатки
	|ГДЕ
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.СуммаОстаток > 0";
	
	Запрос.УстановитьПараметр("ДатаЗаполнения", ДатаЗаполнения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Массив = Новый Массив;
	Если Выборка.Количество() = 0 Тогда
		Возврат Массив;
	Иначе
		Массив = Новый Массив;
		Пока Выборка.Следующий() Цикл
			Структура = ВКМ_ПолезныеФункции.СтрокаВыборкиВСтруктуру(Выборка);
			Массив.Добавить(Структура);
		КонецЦикла;
		Возврат Массив;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли


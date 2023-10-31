
#Если Сервер Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция СформироватьВзаиморасчеты(Документ) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЕСТЬNULL(СУММА(ОсновныеНачисления.Сумма), 0) КАК ОсновныеНачисления
	               |ПОМЕСТИТЬ ВТ_ОсновныеНачисления
	               |ИЗ
	               |	РегистрРасчета.ОсновныеНачисления КАК ОсновныеНачисления
	               |ГДЕ
	               |	ОсновныеНачисления.Регистратор = &Регистратор
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЕСТЬNULL(СУММА(ДополнительныеНачисления.Сумма), 0) КАК ДополнительныеНачисления
	               |ПОМЕСТИТЬ ВТ_ДополнительныеНачисления
	               |ИЗ
	               |	РегистрРасчета.ДополнительныеНачисления КАК ДополнительныеНачисления
	               |ГДЕ
	               |	ДополнительныеНачисления.Регистратор = &Регистратор
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЕСТЬNULL(СУММА(Удержания.Сумма), 0) КАК Удержания
	               |ПОМЕСТИТЬ ВТ_Удержания
	               |ИЗ
	               |	РегистрРасчета.Удержания КАК Удержания
	               |ГДЕ
	               |	Удержания.Регистратор = &Регистратор
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ДополнительныеНачисления.ДополнительныеНачисления КАК ДополнительныеНачисления,
	               |	ВТ_ОсновныеНачисления.ОсновныеНачисления КАК ОсновныеНачисления,
	               |	ВТ_Удержания.Удержания КАК Удержания
	               |ИЗ
	               |	ВТ_ОсновныеНачисления КАК ВТ_ОсновныеНачисления,
	               |	ВТ_ДополнительныеНачисления КАК ВТ_ДополнительныеНачисления,
	               |	ВТ_Удержания КАК ВТ_Удержания";
	
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



#Область ПрограммныйИнтерфейс

Функция ОбработатьВходящийЗапрос(Запрос) Экспорт
	
	//Секрет = Запрос.ПараметрыURL.Получить("secret");
	//
	//Если Секрет <> Константы.ВКМ_СекретТелеграмБота.Получить() Тогда
	//	Ответ = Новый Структура;
	//	Ответ.Вставить("Result", "Error");
	//	Ответ.Вставить("ErrorText", "Wrong secret");
	//	Возврат ВКМ_ОбщегоНазначенияHTTP.ОтветJSON(Ответ, 403);	
	//КонецЕсли;
	
	ДанныеЗапроса = ДанныеЗапроса(Запрос);
	
	Если ДанныеЗапроса.Свойство("message") Тогда
		Возврат ОбработатьСообщение(ДанныеЗапроса.message);		
	КонецЕсли;
	
	Возврат ВКМ_ОбщегоНазначенияHTTP.ПростойУспешныйОтвет();

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВКМ_ОтправкаУведомленийТелеграм() Экспорт
	
	Если НЕ ЗначениеЗаполнено(Константы.ВКМ_ТокенУправленияТелеграмБотом.Получить())
		ИЛИ НЕ ЗначениеЗаполнено(Константы.ВКМ_ИдентификаторГруппыДляОповещения.Получить()) Тогда
		Возврат;
	КонецЕсли;
	
	УведомленияДляОтправки = Справочники.ВКМ_УведомленияДляТелеграма.УведомленияДляОтправки();
	
	Для Каждого ЭлементМассива Из УведомленияДляОтправки Цикл
	
		//Функция для отправки уведомлений
		ОтправитьУведомлениеВЧат(ЭлементМассива.ТекстСообщения);
		ОбъектДляУдаления = ЭлементМассива.Ссылка.ПолучитьОбъект();
		ОбъектДляУдаления.Удалить();
		
	КонецЦикла;

КонецПроцедуры

Функция ДанныеЗапроса(Запрос)
	
	ТелоЗапроса = Запрос.ПолучитьТелоКакСтроку();
	Возврат ВКМ_ОбщегоНазначенияHTTP.ОбъектJSON(ТелоЗапроса);

КонецФункции

Функция ОбработатьСообщение(ДанныеСообщения)
	
	Если ДанныеСообщения.Свойство("from") Тогда
		ЗафиксироватьОтправителя(ДанныеСообщения.from);		
	КонецЕсли;
	
	ИдентификаторЧата = ДанныеСообщения.chat.id;
	
	Если ДанныеСообщения.Свойство("text") Тогда
		ТекстСообщения = ДанныеСообщения.text;
	Иначе
		ТекстСообщения = "Пустое сообщение =(";
	КонецЕсли;
	
	ДанныеОтвета = Новый Структура;
	ДанныеОтвета.Вставить("method", "sendMessage");
	ДанныеОтвета.Вставить("chat_id", ИдентификаторЧата);
	ДанныеОтвета.Вставить("text", ТекстСообщения);
	ДанныеОтвета.Вставить("reply_markup", Клавиатура());
	
	Возврат ВКМ_ОбщегоНазначенияHTTP.ОтветJSON(ДанныеОтвета);

КонецФункции 

Процедура ОтправитьУведомлениеВЧат(ТекстСообщения) Экспорт
	
	SSL = Новый ЗащищенноеСоединениеOpenSSL(Новый СертификатКлиентаWindows(), Новый СертификатыУдостоверяющихЦентровWindows());
	
	Заголовки  = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить("/bot");
	МассивСтрок.Добавить(Строка(Константы.ВКМ_ТокенУправленияТелеграмБотом.Получить()));
	МассивСтрок.Добавить("/sendMessage?chat_id=");
	МассивСтрок.Добавить(Строка(Константы.ВКМ_ИдентификаторГруппыДляОповещения.Получить()));
	МассивСтрок.Добавить("&text=");
	МассивСтрок.Добавить(ТекстСообщения);
	
	Ресурс = СтрСоединить(МассивСтрок);
	
	Адрес = "api.telegram.org";
		
	HTTPМетод = "POST";
  	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	
	HTTPСоединение = Новый HTTPСоединение(Адрес,443,,,,60,SSL); 
	HTTPОтвет = HTTPСоединение.ВызватьHTTPМетод(HTTPМетод, HTTPЗапрос);
	Ответ = HTTPОтвет.ПолучитьТелоКакСтроку();

КонецПроцедуры

Функция Клавиатура()
	
	СтрокиКлавиатуры = Новый Массив;
	КнопкиСтрокиКлавиатуры = Новый Массив;
	
	КнопкаКлавиатуры = Новый Структура;
	КнопкаКлавиатуры.Вставить("text", "=(");
	КнопкиСтрокиКлавиатуры.Добавить(КнопкаКлавиатуры);
	
	КнопкаКлавиатуры = Новый Структура;
	КнопкаКлавиатуры.Вставить("text", "=)");
	КнопкиСтрокиКлавиатуры.Добавить(КнопкаКлавиатуры);
	
	СтрокиКлавиатуры.Добавить(КнопкиСтрокиКлавиатуры);
	
	ДанныеКлавиатуры = Новый Структура;
	ДанныеКлавиатуры.Вставить("keyboard", СтрокиКлавиатуры);
	
	Возврат ДанныеКлавиатуры; 

КонецФункции

Процедура ЗафиксироватьОтправителя(ДанныеОтправителя);
	
	Идентификатор = ДанныеОтправителя.id;
	УчетнаяЗапись = Справочники.ВКМ_УчетныеЗаписиТелеграм.НайтиПоКоду(Идентификатор);
	
	Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		Возврат;	
	КонецЕсли;
	
	ЧастиИмениПользователя = Новый Массив;       
	
	Если ДанныеОтправителя.Свойство("first_name") Тогда
		ЧастиИмениПользователя.Добавить(ДанныеОтправителя.first_name);		
	КонецЕсли;
	
	Если ДанныеОтправителя.Свойство("last_name") Тогда
		ЧастиИмениПользователя.Добавить(ДанныеОтправителя.last_name);		
	КонецЕсли;
	
	Если ДанныеОтправителя.Свойство("username") Тогда
		ЧастиИмениПользователя.Добавить(ДанныеОтправителя.username);		
	КонецЕсли;
	
	ИмяПользователя = СтрСоединить(ЧастиИмениПользователя, " ");
	
	СпрОбъъект = Справочники.ВКМ_УчетныеЗаписиТелеграм.СоздатьЭлемент();
	СпрОбъъект.Наименование = ИмяПользователя;
	СпрОбъъект.Код = Идентификатор;
	СпрОбъъект.Записать();
	
КонецПроцедуры

#КонецОбласти
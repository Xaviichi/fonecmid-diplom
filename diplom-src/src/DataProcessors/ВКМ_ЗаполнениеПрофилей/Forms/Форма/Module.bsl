
&НаСервере
Процедура ЗаполнениеПрофилейДоступаНаСервере()
	
	Справочники.ПрофилиГруппДоступа.ЗаполнитьПрофилиТП();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеПрофилейДоступа(Команда)
	ЗаполнениеПрофилейДоступаНаСервере();
КонецПроцедуры

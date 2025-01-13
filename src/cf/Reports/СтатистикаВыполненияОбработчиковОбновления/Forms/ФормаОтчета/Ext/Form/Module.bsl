﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	
	НачатьЗагрузкуЖурналаНаСервер(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	Если НЕ ЭтоАдресВременногоХранилища(Отчет.АдресДанных) Тогда
		НачатьЗагрузкуЖурналаНаСервер(Истина);
		Возврат;
	КонецЕсли;
	
	СформироватьОтчетНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчетНаСервере()
	
	Результат.Очистить();
	
	ИнформацияРасшифровки = Неопределено;
	РеквизитФормыВЗначение("Отчет").СкомпоноватьРезультат(Результат, ИнформацияРасшифровки);
	ДанныеРасшифровки = ПоместитьВоВременноеХранилище(ИнформацияРасшифровки, УникальныйИдентификатор);
	Элементы.Результат.ОтображениеСостояния.Видимость = Ложь;
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьЗагрузкуЖурналаНаСервер(Знач СформироватьПослеЗагрузки)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьРезультатПомещенияФайла", 
		ЭтотОбъект, СформироватьПослеЗагрузки);
	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатПомещенияФайла(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отчет.АдресДанных = ПомещенныйФайл.Хранение;
	Если ДополнительныеПараметры Тогда
		СформироватьОтчетНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
﻿///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ТЦТест.ВывестиПараметрыТеста(СводныйОтчет, Объект.Ссылка);
	
	ОценкаПроизводительностиИспользуется = ТЦСервер.ОценкаПроизводительностиИспользуется();
	Если ОценкаПроизводительностиИспользуется Тогда
		ТЦСервер.СформироватьОтчетПоПроизводительности(Объект.Ссылка, ОтчетПроизводительности, СводныйОтчет);
	КонецЕсли;
	
	Схема = Объект.Ссылка.ПолучитьОбъект().ПолучитьМакет("Показатели");
	ТЦСервер.СформироватьОтчет(Схема, Отчет, Новый Структура("Тест", Объект.Ссылка),,);
	
	ВыполненоСОшибкой = Ложь;
	Если Объект.Результат = Перечисления.ТЦРезультатВыполнения.Ошибка Тогда
		ВыполненоСОшибкой = Истина;
		ОшибкаСтруктура = Объект.Ссылка.ИнформацияОбОшибке.Получить();
		ОписаниеОшибки = ОшибкаСтруктура.Описание;
		РасшифровкаОшибки = ТЦОбщий.ИнформациюОбОшибкеВСтроку(ОшибкаСтруктура);
	КонецЕсли;
	
	ЗапросПоОшибкам = Новый Запрос;
	ЗапросПоОшибкам.Текст = "ВЫБРАТЬ
	                        |	КОЛИЧЕСТВО(*) КАК КоличествоОшибок
	                        |ИЗ
	                        |	РегистрСведений.ТЦОшибки КАК ТЦОшибки
	                        |ГДЕ
	                        |	ТЦОшибки.Тест = &Тест";
					  
	ЗапросПоОшибкам.УстановитьПараметр("Тест", Объект.Ссылка);
	Результат = ЗапросПоОшибкам.Выполнить();
	
	БылиОшибки = Ложь;
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Если Выборка.КоличествоОшибок > 0 Тогда
			БылиОшибки = Истина;
			ТЦСервер.СформироватьОтчетПоОшибкам(Объект.Ссылка, ОтчетПоОшибкам, СводныйОтчет);
		КонецЕсли;
	КонецЕсли;

	ТЦСервер.СформироватьОтчетПоПротоколу(Объект.Дата, Объект.ДатаОкончания, Протокол, СводныйОтчет);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьЭлементов();
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// УПРАВЛЕНИЕ ФОРМОЙ

&НаКлиенте
Процедура УстановитьВидимостьЭлементов()
	
	Если Объект.ТаблицаРаспределения.Количество() > 0 Тогда
		Элементы.ТаблицаРаспределения.Видимость = Истина;
	Иначе
		Элементы.ТаблицаРаспределения.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.Производительность.Видимость = ОценкаПроизводительностиИспользуется;
	Элементы.ПроизводительностьИтераций.Видимость = ОценкаПроизводительностиИспользуется;
	Элементы.ПороговыйAPDEX.Видимость= ОценкаПроизводительностиИспользуется;	
	Элементы.КонечныйШагДозапускаПользователей.Видимость= ОценкаПроизводительностиИспользуется;	
	
	Если ОценкаПроизводительностиИспользуется Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.Производительность;
	КонецЕсли;
	
	Элементы.ИнформацияОбОшибках.Видимость = (ВыполненоСОшибкой ИЛИ БылиОшибки);
	Элементы.ОтчетПоОшибкам.Видимость = БылиОшибки;
	Элементы.ОписаниеКритическойОшибки.Видимость = ВыполненоСОшибкой;
	Элементы.КомандаПодробнее.Видимость = ВыполненоСОшибкой;
		
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОшибкуПодробнее(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ошибка", ОшибкаСтруктура);
	ПараметрыФормы.Вставить("ДатаНачала", Объект.ДатаОкончания - 3);
	ПараметрыФормы.Вставить("ДатаОкончания", Объект.ДатаОкончания + 3);
	
	ОткрытьФорму("ОбщаяФорма.ТЦОшибкаПодробнее", ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьАнализЗамеров(Команда)
	
	ФормаОтчета = ПолучитьФорму("Отчет.ТЦАнализЗамеров.Форма",,, Объект.Ссылка);
	
	КомпоновщикНастроек = ФормаОтчета.Отчет.КомпоновщикНастроек;
	
	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Тест");
	ПараметрПользовательский = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Параметр.ИдентификаторПользовательскойНастройки);
	ПараметрПользовательский.Значение = Объект.Ссылка;
	ПараметрПользовательский.Использование = Истина;
	
	ФормаОтчета.СкомпоноватьРезультат();
	ФормаОтчета.Открыть();
	
КонецПроцедуры

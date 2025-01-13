﻿&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Попытка
		ДатаНачала = ТекущаяДата();
		ЗаполнитьСписокПользователей();
	Исключение
		Ошибка = ИнформацияОбОшибке();
		ТЦОбщий.ЗаписатьВЖурнал(Ошибка);
		ТЦКлиент.СообщитьОбОшибке(Ошибка, ДатаНачала, ТекущаяДата());
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИнформационнойБазыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Попытка
		ДатаНачала = ТекущаяДата();
		ВыбратьПользователя(ВыбранноеЗначение);
	Исключение
		Ошибка = ИнформацияОбОшибке();
		ТЦОбщий.ЗаписатьВЖурнал(Ошибка);
		ТЦКлиент.СообщитьОбОшибке(Ошибка, ДатаНачала, ТекущаяДата());
	КонецПопытки;
КонецПроцедуры

&НаСервереБезКонтекста
// Получить представление имени пользователя
//
// Параметры:
//  Имя - Строка, имя пользователя информационной базы
//
// Возвращаемое значение:
//  Строка - полное имя пользователя
//
Функция ПредставлениеИмени(Пользователь)
	
	Представление = Пользователь.Имя;
	
	Если Пользователь.АутентификацияОС Тогда
		Представление = Представление + " (" + Пользователь.ПользовательОС + ")";
	КонецЕсли;
	
	Если ТЦСервер.ЕстьРазделители() Тогда
		РазделителиВСтроку = ТЦСервер.РазделителиПользователяИБВСтроку(Пользователь);
	Иначе
		РазделителиВСтроку = "";
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(РазделителиВСтроку) Тогда
		Представление = Представление + "; " + РазделителиВСтроку;
	КонецЕсли;

	Возврат Представление;
	
КонецФункции // ПредставлениеИмени()

&НаКлиенте
// Выполнить все, что необходимо при выборе пользователя
//
// Параметры:
//  ВыбранныйИдентификаторПользователяИБ — уникальный идентификатор пользователя
//
Процедура ВыбратьПользователя(ВыбранныйИдентификаторПользователяИБ)
	
	РезультатВыбора = ВыбратьПользователяНаСервере(ВыбранныйИдентификаторПользователяИБ);
	Объект.Имя = РезультатВыбора.Имя;
	Объект.Наименование = РезультатВыбора.Наименование;
	Объект.ТипАутентификации = РезультатВыбора.ТипАутентификации;
	
	Объект.Разделители.Очистить();
	Для Каждого ТекРазделитель Из РезультатВыбора.Разделители Цикл
		НоваяСтрока = Объект.Разделители.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекРазделитель);
	КонецЦикла;
	
КонецПроцедуры

// Получить свойства выбранного пользователя на сервере
//
// Параметры:
//  ВыбранныйИдентификаторПользователяИБ — уникальный идентификатор пользователя
//
// Результат:
//  Структура
//
&НаСервереБезКонтекста
Функция ВыбратьПользователяНаСервере(ВыбранныйИдентификаторПользователяИБ)
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Новый Структура;
	
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
		Новый УникальныйИдентификатор(ВыбранныйИдентификаторПользователяИБ)
	);
	
	Результат.Вставить("Имя", ПользовательИБ.Имя);
	
	Представление = ПредставлениеИмени(ПользовательИБ);
	Результат.Вставить("Наименование", Представление);
	
	Если ПользовательИБ.АутентификацияОС Тогда
		Результат.Вставить("ТипАутентификации", Перечисления.ТЦТипАутентификации.АутентификацияОС);
	ИначеЕсли ПользовательИБ.АутентификацияСтандартная Тогда
		Результат.Вставить("ТипАутентификации", Перечисления.ТЦТипАутентификации.Аутентификация1С);
	КонецЕсли;
	
	Результат.Вставить("Разделители", Новый Массив);
	
	СтруктураРазделителей = ПользовательИБ.РазделениеДанных;
	Для Каждого СтрокаРазделителя Из СтруктураРазделителей Цикл
		
		Результат.Разделители.Добавить(
			Новый Структура("Ключ,Значение", СтрокаРазделителя.Ключ, СтрокаРазделителя.Значение)
		);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции // ВыбратьПользователяНаСервере()

&НаСервере
// Заполнить список пользователей
//
Процедура ЗаполнитьСписокПользователей()
	
	Перем Пользователи;
	
	УстановитьПривилегированныйРежим(Истина);
	Пользователи = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	Если Пользователи.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаПользователей = Новый ТаблицаЗначений;
	ТипСтрока150 = Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(150));
	
	ТаблицаПользователей.Колонки.Добавить("Идентификатор", ТипСтрока150);
	ТаблицаПользователей.Колонки.Добавить("Имя", ТипСтрока150);
	СсылкиНаПользователейИБ = Новый Соответствие;
	
	Для каждого Пользователь Из Пользователи Цикл
		Если Найти(Пользователь.Имя, "_ТЦ") > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПользователя = ТаблицаПользователей.Добавить();
		ИдентификаторПользователяИБВСтроку = Строка(Пользователь.УникальныйИдентификатор);
		
		СтрокаПользователя.Идентификатор = ИдентификаторПользователяИБВСтроку;
		СтрокаПользователя.Имя = Пользователь.Имя;
		
		СсылкиНаПользователейИБ.Вставить(
			ИдентификаторПользователяИБВСтроку,
			Пользователь
		);
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Пользователи", ТаблицаПользователей);
	Запрос.УстановитьПараметр("ТекущийИдентификаторПользователяИБ", Объект.Ссылка.ИдентификаторПользователяИБ);
	
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	Пользователи.Идентификатор,
		|	Пользователи.Имя
		|ПОМЕСТИТЬ
		|	ВсеПользователи
		|ИЗ
		|	&Пользователи КАК Пользователи
		|;
		|
		|ВЫБРАТЬ
		|	Идентификатор, Имя
		|ИЗ
		|	ВсеПользователи
		|ГДЕ
		|	Идентификатор НЕ В
		|	(
		|		ВЫБРАТЬ
		|			ИдентификаторПользователяИБ
		|		ИЗ
		|			Справочник.ТЦПользователи
		|		ГДЕ
		|			ИдентификаторПользователяИБ <> &ТекущийИдентификаторПользователяИБ
		|	)
		|УПОРЯДОЧИТЬ ПО
		|	Имя";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	СписокВыбора = Элементы.ПользовательИнформационнойБазы.СписокВыбора;
	
	Пока Выборка.Следующий() Цикл
		
		ИдентификаторПользователяИБВСтроку = Выборка.Идентификатор;
		
		ПользовательИБ = СсылкиНаПользователейИБ.Получить(ИдентификаторПользователяИБВСтроку);
		Представление = ПредставлениеИмени(ПользовательИБ);
		
		ЭлементВыбора = СписокВыбора.Добавить(
			ИдентификаторПользователяИБВСтроку,
			Представление
		);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьСписокПользователей()

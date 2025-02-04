﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.КоличествоОдновременноЗапускаемыхВРМАгента < 1 Тогда
		Объект.КоличествоОдновременноЗапускаемыхВРМАгента = ТЦОбщий.КоличествоОдновременноЗапускаемыхВРМАгентаПоУмолчанию();
		Модифицированность = Истина;
		Сообщить(НСтр("ru = 'Параметр «Количество одновременно запускаемых ВРМ» был автоматически установлен в значение «" + Объект.КоличествоОдновременноЗапускаемыхВРМАгента + "».'"));
	КонецЕсли;
	
	Если Объект.ТаймаутОпросаАгентов < 1 Тогда
		Объект.ТаймаутОпросаАгентов = ТЦОбщий.ТаймаутОпросаАгентовПоУмолчанию();
		Модифицированность = Истина;
		Сообщить(НСтр("ru = 'Параметр «Таймаут опроса агентов» был автоматически установлен в значение «" + Объект.ТаймаутОпросаАгентов + "».'"));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура АвтоТаймаутПодготовки(Команда)
	
	Максимум = МаксимумКлиентовНаКомпьютере();
	Объект.ТаймаутПодготовки =
		ТЦОбщий.ОкрВверх(Максимум / 10) * Объект.ТаймаутЗапускаКлиента + 60;
	
КонецПроцедуры // АвтоТаймаутПодготовки()

&НаСервере
// Определить максимальное количество клиентов, запускаемых на одном компьютере
//
// Параметры:
//  Сценарий
//
// Возвращаемое значение:
//  Число - максимальное количество клиентов
//
Функция МаксимумКлиентовНаКомпьютере()
	
	Компьютеры = Объект.Структура.Выгрузить(, "Клиент, Количество");
	Компьютеры.Колонки.Добавить("Компьютер");
	
	Для каждого СтрокаКомпьютера Из Компьютеры Цикл
		СтрокаКомпьютера.Компьютер = СтрокаКомпьютера.Клиент.Компьютер;
	КонецЦикла;
	
	Компьютеры.Свернуть("Компьютер", "Количество");
	Максимум = 0;
	
	Для каждого СтрокаКомпьютера Из Компьютеры Цикл
		Если СтрокаКомпьютера.Количество > Максимум Тогда
			Максимум = СтрокаКомпьютера.Количество;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Максимум;
	
КонецФункции // МаксимумКлиентовНаКомпьютере()

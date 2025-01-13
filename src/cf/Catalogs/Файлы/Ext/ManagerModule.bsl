﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Возврат РаботаСФайлами.РеквизитыРедактируемыеВГрупповойОбработке();
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(ВладелецФайла)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ИзменениеОбъектаРазрешено(ВладелецФайла)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"РазрешитьЧтение
	|ГДЕ
	|	ВЫБОР 
	|		КОГДА ТипЗначения(ВладелецФайла) = Тип(Справочник.ПапкиФайлов)
	|			ТОГДА ЧтениеОбъектаРазрешено(ВЫРАЗИТЬ(ВладелецФайла КАК Справочник.ПапкиФайлов))
	|		ИНАЧЕ ЗначениеРазрешено(ВЫРАЗИТЬ(Автор КАК Справочник.ВнешниеПользователи))
	|	КОНЕЦ
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ВЫБОР 
	|		КОГДА ТипЗначения(ВладелецФайла) = Тип(Справочник.ПапкиФайлов)
	|			ТОГДА ИзменениеОбъектаРазрешено(ВЫРАЗИТЬ(ВладелецФайла КАК Справочник.ПапкиФайлов))
	|		ИНАЧЕ ЗначениеРазрешено(ВЫРАЗИТЬ(Автор КАК Справочник.ВнешниеПользователи))
	|	КОНЕЦ";
	Ограничение.ПоВладельцуБезЗаписиКлючейДоступаДляВнешнихПользователей = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульСозданиеНаОсновании = ОбщегоНазначения.ОбщийМодуль("СозданиеНаОсновании");
		Возврат МодульСозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Справочники.Файлы);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если Параметры.Количество() = 0 Тогда
		ВыбраннаяФорма = "Файлы"; // Т.к. не указан конкретный файл, то открываем список файлов.
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	Если ВидФормы = "ФормаСписка" Тогда
		ТекущаяСтрока = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ТекущаяСтрока");
		Если ТипЗнч(ТекущаяСтрока) = Тип("СправочникСсылка.Файлы") И Не ТекущаяСтрока.Пустая() Тогда
			СтандартнаяОбработка = Ложь;
			ВладелецФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущаяСтрока, "ВладелецФайла");
			Если ТипЗнч(ВладелецФайла) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
				Параметры.Вставить("Папка", ВладелецФайла);
				ВыбраннаяФорма = "Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы";
			Иначе
				Параметры.Вставить("ВладелецФайла", ВладелецФайла);
				ВыбраннаяФорма = "Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОтработаныВсеФайлы = Ложь;
	Ссылка = "";
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Справочник.Файлы";
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Пока Не ОтработаныВсеФайлы Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1000
			|	Файлы.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Файлы КАК Файлы
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОФайлах КАК СведенияОФайлах
			|		ПО Файлы.Ссылка = СведенияОФайлах.Файл
			|ГДЕ
			|	((Файлы.ДатаМодификацииУниверсальная = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
			|					И Файлы.ТекущаяВерсия <> ЗНАЧЕНИЕ(Справочник.ВерсииФайлов.ПустаяСсылка)
			|				ИЛИ Файлы.ТипХраненияФайла = ЗНАЧЕНИЕ(Перечисление.ТипыХраненияФайлов.ПустаяСсылка))
			|				И Файлы.Ссылка > &Ссылка
			|			ИЛИ СведенияОФайлах.Файл ЕСТЬ NULL)
			|
			|УПОРЯДОЧИТЬ ПО
			|	Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
		
		КоличествоСсылок = МассивСсылок.Количество();
		Если КоличествоСсылок < 1000 Тогда
			ОтработаныВсеФайлы = Истина;
		КонецЕсли;
		
		Если КоличествоСсылок > 0 Тогда
			Ссылка = МассивСсылок[КоличествоСсылок - 1];
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	ВыбранныеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Для Каждого Строка Из ВыбранныеДанные Цикл
		
		НачатьТранзакцию();
		Попытка
			
			БлокировкаДанных = Новый БлокировкаДанных;
			ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("Справочник.Файлы");
			ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", Строка.Ссылка);
			
			ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("Справочник.ВерсииФайлов");
			ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", Строка.Ссылка.ТекущаяВерсия);
			ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Разделяемый;
			
			БлокировкаДанных.Заблокировать();
			
			ОбновляемыйФайл = Строка.Ссылка.ПолучитьОбъект(); // СправочникОбъект.Файлы
			ОбновляемыйФайл.ДатаМодификацииУниверсальная = ОбновляемыйФайл.ТекущаяВерсия.ДатаМодификацииУниверсальная;
			ОбновляемыйФайл.ТипХраненияФайла             = ОбновляемыйФайл.ТекущаяВерсия.ТипХраненияФайла;
			
			НаборЗаписей = РегистрыСведений.СведенияОФайлах.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Файл.Установить(Строка.Ссылка);
			НаборЗаписей.Прочитать();
			Если НаборЗаписей.Количество() = 0 Тогда
				СведенияОФайле = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(СведенияОФайле, ОбновляемыйФайл);
				СведенияОФайле.Файл          = ОбновляемыйФайл.Ссылка;
				АвторИВладелец               = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОбновляемыйФайл.Ссылка, "Автор, ВладелецФайла");
				СведенияОФайле.Автор         = АвторИВладелец.Автор;
				СведенияОФайле.ВладелецФайла = АвторИВладелец.ВладелецФайла;
				
				Если ОбновляемыйФайл.ПодписанЭП И ОбновляемыйФайл.Зашифрован Тогда
					СведенияОФайле.НомерКартинкиПодписанЗашифрован = 2;
				ИначеЕсли ОбновляемыйФайл.Зашифрован Тогда
					СведенияОФайле.НомерКартинкиПодписанЗашифрован = 1;
				ИначеЕсли ОбновляемыйФайл.ПодписанЭП Тогда
					СведенияОФайле.НомерКартинкиПодписанЗашифрован = 0;
				Иначе
					СведенияОФайле.НомерКартинкиПодписанЗашифрован = -1;
				КонецЕсли;
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбновляемыйФайл);
			
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Строка.Ссылка);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			// Если не удалось обработать какой-либо документ, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать файл %1 по причине:
				|%2'"), 
				Строка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Строка.Ссылка.Метаданные(), Строка.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.Файлы") Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать файлы (пропущены): %1'"), 
			ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
			УровеньЖурналаРегистрации.Информация, , ,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обработана очередная порция файлов: %1'"),
				ОбъектовОбработано));
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли


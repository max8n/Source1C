﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПрограммноеЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ДанныеПодтверждения = Неопределено Тогда
		Параметры.ДанныеПодтверждения = СервисКриптографииDSSПодтверждениеСервер.ДанныеВторичнойАвторизацииПоУмолчанию();
		ВремяИстекло = Истина;
	КонецЕсли;
	
	Если Параметры.НастройкиПользователя = Неопределено Тогда
		Параметры.НастройкиПользователя = СервисКриптографииDSS.НастройкиПользователяПоУмолчанию();
		ВремяИстекло = Истина;
	КонецЕсли;
	
	СервисКриптографииDSSПодтверждениеСервер.ПодготовитьФормуПодтвержденияПриСоздании(ЭтотОбъект);
	ДанныеПодтверждения.СрокОпроса = ТекущаяДатаСеанса() - ДанныеПодтверждения.ПериодОпроса;
	
	НазначитьКлючСохраненияФормы();
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СервисКриптографииDSSСлужебныйКлиент.ПриОткрытииФормы(ЭтотОбъект, ПрограммноеЗакрытие);
	ПриНачалеПодтверждения();
	СервисКриптографииDSSПодтверждениеКлиент.ФильтроватьСписокСпособов(ЭтотОбъект, "СпособПодтверждения");
	
	СервисКриптографииDSSПодтверждениеКлиент.ПодключитьОжидание(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если СервисКриптографииDSSСлужебныйКлиент.ПередЗакрытиемФормы(
			ЭтотОбъект,
			Отказ,
			ПрограммноеЗакрытие,
			ЗавершениеРаботы) Тогда
		ЗакрытьФорму();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("ПодтверждениеЗакрытьФорму") И Источник = УникальныйИдентификатор Тогда
		ЗакрытьФорму(Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособПодтвержденияПриИзменении(Элемент)
	
	СервисКриптографииDSSПодтверждениеКлиент.ПриИзмененииСпособаПодтверждения(ЭтотОбъект);
	
КонецПроцедуры
	
&НаКлиенте
Процедура СертификатНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОперации = СервисКриптографииDSSСлужебныйКлиент.ПодготовитьПараметрыОперации(Ложь);
	ПараметрыОперации.ИдентификаторОперации = УникальныйИдентификатор;
	ПараметрыОперации.Вставить("ФормаВладелец", ЭтотОбъект);
	
	СервисКриптографииDSSКлиент.ПоказатьСертификат(
		Неопределено, 
		НастройкиПользователя,
		Новый Структура("Отпечаток", Сертификат.Отпечаток),
		ПараметрыОперации);

КонецПроцедуры

&НаКлиенте
Процедура ДокументыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СервисКриптографииDSSПодтверждениеКлиент.ОбработкаНавигационнойСсылкиДокументов(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакрытьФорму(ПараметрыЗакрытия = Неопределено)
	
	ПрограммноеЗакрытие = Истина;
	
	Если ПараметрыЗакрытия = Неопределено Тогда
		ДанныеПодтверждения.ЭтапЦикла = "Окончание";
		ПараметрыЗакрытия = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Ложь, "ОтказПользователя");
	КонецЕсли;	
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПодтверждениеОбработчикОжидания()
	
	ОбработкаЦиклаОжидания();
	
КонецПроцедуры

&НаКлиенте
Функция ДатаСеанса()
	
	Возврат СервисКриптографииDSSСлужебныйКлиент.ДатаСеанса();
	
КонецФункции

&НаКлиенте
Процедура ОбработкаЦиклаОжидания()
	
	Разница = 0;
	Если ЗначениеЗаполнено(ДанныеПодтверждения.СрокДействия) Тогда
		Разница = ДанныеПодтверждения.СрокДействия - ДатаСеанса();
	КонецЕсли;
	
	Если Разница > 0 Тогда
		Осталось = СервисКриптографииDSSПодтверждениеКлиент.РазницаФормат(Разница);
	ИначеЕсли НЕ ЗначениеЗаполнено(ДанныеПодтверждения.СрокДействия) Тогда
		Осталось = "";
	Иначе
		Осталось = НСтр("ru = 'Время истекло'", СервисКриптографииDSSСлужебныйКлиент.КодЯзыка());
		ВремяИстекло = Истина;
		ПриНачалеПодтверждения();
	КонецЕсли;
	
	Если ДанныеПодтверждения.ЭтапЦикла = "Ожидание" Тогда
		Разница = ДатаСеанса() - ДанныеПодтверждения.СрокОпроса;
		Если Разница > ДанныеПодтверждения.ПериодОпроса Тогда
			ОтправкаЗапросаКлиент();
			ДанныеПодтверждения.СрокОпроса = ДатаСеанса();
		КонецЕсли;
	КонецЕсли;	

	СервисКриптографииDSSПодтверждениеКлиент.ПодключитьОжидание(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправкаЗапросаКлиент()

	ОжидатьВыполнения	= Истина;
	ОбработчикОтвета	= Новый ОписаниеОповещения("ПолучениеРезультатаФоновогоЗадания", ЭтотОбъект);
	СервисКриптографииDSSПодтверждениеКлиент.ОтправкаЗапроса(ОбработчикОтвета, НастройкиПользователя, ДанныеПодтверждения);
	ПриНачалеПодтверждения();

КонецПроцедуры

&НаКлиенте
Процедура ПолучениеРезультатаФоновогоЗадания(Результат, ДополнительныеПараметры) Экспорт
	
	Если Открыта() Тогда
		ОжидатьВыполнения	= Ложь;
		РезультатЗапроса 	= СервисКриптографииDSSСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат, ДанныеПодтверждения);
		ОповещениеСледующее	= Новый ОписаниеОповещения("ПослеОбработкиОтветаСервера", ЭтотОбъект, ДанныеПодтверждения);
		СервисКриптографииDSSПодтверждениеКлиент.ОбработатьРезультатЗапроса(ОповещениеСледующее, 
													РезультатЗапроса, 
													НастройкиПользователя, 
													ДанныеПодтверждения,
													ЭтотОбъект);
			
		ПриНачалеПодтверждения();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОбработкиОтветаСервера(РезультатВызова, ДополнительныеПараметры) Экспорт
	
	РезультатВыполнения 	= СервисКриптографииDSSСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(РезультатВызова, ДанныеПодтверждения);
	Если РезультатВыполнения.Выполнено Тогда
		ДанныеПодтверждения = РезультатВыполнения.ДанныеПодтверждения;
		Если ДанныеПодтверждения.ЭтапЦикла = "Окончание" Тогда
			ОтветПользователя = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию();
			ОтветПользователя.Вставить("НастройкиПользователя", РезультатВыполнения.НастройкиПользователя);
			ОтветПользователя.Вставить("ДанныеПодтверждения", ДанныеПодтверждения);
			ЗакрытьФорму(ОтветПользователя);
		ИначеЕсли ДанныеПодтверждения.ЭтапЦикла = "Отказ" Тогда
			ОтветПользователя = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Ложь, "authentication_declined");
			ОтветПользователя.Вставить("НастройкиПользователя", НастройкиПользователя);
			ОтветПользователя.Вставить("ДанныеПодтверждения", ДанныеПодтверждения);
			ЗакрытьФорму(ОтветПользователя);
		ИначеЕсли ДанныеПодтверждения.ЭтапЦикла = "Начало" Тогда
			ВремяИстекло = Ложь;
			ОтправкаЗапросаКлиент();
		ИначеЕсли ДанныеПодтверждения.ЭтапЦикла <> "Ошибка" Тогда
			ДанныеПодтверждения.ЭтапЦикла = "Ожидание";
			ПриНачалеПодтверждения();
		КонецЕсли;
		
	ИначеЕсли НЕ СервисКриптографииDSSКлиентСервер.ЭтоОшибкаОтказа(РезультатВыполнения.Ошибка) Тогда
		ЗакрытьФорму(РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриНачалеПодтверждения()
	
	СервисКриптографииDSSПодтверждениеКлиент.ВывестиИнформациюСервера(ЭтотОбъект, "ИнформацияСервера");
	СервисКриптографииDSSПодтверждениеКлиент.ОформитьВремяИстекло(Элементы.ГруппаПодвал, ВремяИстекло);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	ЭлементыФормы = Элементы;
	ЭлементыФормы.Сертификат.Видимость = ЗначениеЗаполнено(Сертификат);
	ЭлементыФормы.Документы.Видимость = ЗначениеЗаполнено(ПредставлениеДокументов);
	
КонецПроцедуры

&НаСервере
Процедура НазначитьКлючСохраненияФормы()
	
	НовыйКлюч = СервисКриптографииDSSКлиентСервер.ПолучитьПолеСтруктуры(ДанныеПодтверждения, "ТипПодтверждения", ""); 
	
	Если ЗначениеЗаполнено(Сертификат) Тогда
		НовыйКлюч = НовыйКлюч + "Сертификат";
	КонецЕсли;
	 
	Если ЗначениеЗаполнено(ПредставлениеДокументов) Тогда
		НовыйКлюч = НовыйКлюч + "Документ";
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = НовыйКлюч;
	
КонецПроцедуры

#КонецОбласти
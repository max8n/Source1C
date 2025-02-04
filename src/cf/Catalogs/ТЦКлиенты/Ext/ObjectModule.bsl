﻿#Если Не ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Попытка
		ДатаНачала = ТекущаяДата();
		Если ПроверитьЗаполнение() Тогда
			СтрокаЗапуска = СобратьСтрокуЗапуска();
		Иначе
			Отказ = Истина;
		КонецЕсли;
	Исключение
		Отказ = Истина;
		Ошибка = ИнформацияОбОшибке();
		ТЦОбщий.ЗаписатьВЖурнал(Ошибка);
	КонецПопытки;
	
КонецПроцедуры // ПередЗаписью()

// Собрать строку запуска из значений реквизитов
//
// Возвращаемое значение:
//  Строка - строка запуска клиента
//
Функция СобратьСтрокуЗапуска() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	ЭтоLinux = СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86
	       Или СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64;
	
	СтрокаЗапуска = "%EXE%";
	
	Если Не АвтоПуть Тогда
		КорректноеИмяКаталога = ТЦОбщий.СкорректироватьПуть(ИмяКаталога);
		
		Если ЗначениеЗаполнено(КорректноеИмяКаталога) Тогда
			РазделительПути = ТЦОбщий.ОпределитьРазделительПути(ИмяКаталога);
		Иначе
			РазделительПути = "";
		КонецЕсли; 
		
		Путь = КорректноеИмяКаталога + РазделительПути + ИмяФайла;
		СтрокаЗапуска = СтрЗаменить(СтрокаЗапуска, "%EXE%", ТЦОбщий.ЭкранироватьСтроку(Путь));
	КонецЕсли;
	
	Если ТипКлиента = Перечисления.ТЦТипКлиента.ТолстыйУправляемый Или
	     ТипКлиента = Перечисления.ТЦТипКлиента.ТолстыйОбычный Тогда
		СтрокаЗапуска = СтрокаЗапуска + " ENTERPRISE";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДополнительныеПараметры) Тогда
		СтрокаЗапуска = СтрокаЗапуска + " " + ДополнительныеПараметры;
	КонецЕсли;
	
	Если ТипКлиента = Перечисления.ТЦТипКлиента.ТолстыйОбычный Тогда
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "RunModeOrdinaryApplication",, ЭтоLinux);
	ИначеЕсли ТипКлиента = Перечисления.ТЦТипКлиента.ТолстыйУправляемый Тогда
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "RunModeManagedApplication",, ЭтоLinux);
	ИначеЕсли ТипКлиента = Перечисления.ТЦТипКлиента.Веб Тогда
		Если ТипБраузера = Перечисления.ТЦТипБраузера.ПоУмолчанию Тогда
			СтрокаЗапуска = "";
		КонецЕсли;
		
		Разделитель = ?(ПустаяСтрока(СтрокаЗапуска), "", " ");
		СтрокаЗапуска = СтрокаЗапуска + Разделитель + ТЦОбщий.ЭкранироватьСтрокуURL(АдресБраузера);
	КонецЕсли;
	
	Если НеПредупреждать Тогда
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "DisableStartupMessages",, ЭтоLinux);
	КонецЕсли;
	
	Если РазрешатьОтладку Тогда
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "Debug",, ЭтоLinux);
	КонецЕсли;
	
	Если РазрешатьОтладку И НачинатьОтладку Тогда
		Если ЗначениеЗаполнено(АдресОтладчика) Тогда
			СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
				ТипКлиента, СтрокаЗапуска, "DebuggerURL", АдресОтладчика, ЭтоLinux);
		КонецЕсли;
	КонецЕсли;
	
	Если ТипКлиента <> Перечисления.ТЦТипКлиента.ТолстыйОбычный И ОтображатьПоказатели Тогда
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "DisplayPerformance",, ЭтоLinux);
	КонецЕсли;
	
	Если ТипКлиента <> Перечисления.ТЦТипКлиента.ТолстыйОбычный И ОтображатьВсеФункции Тогда
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "DisplayAllFunctions",, ЭтоLinux);
	КонецЕсли;
	
	ЭтоВеб = ТипКлиента = Перечисления.ТЦТипКлиента.Веб;
	ЭтоТонкий1С = ТипКлиента = Перечисления.ТЦТипКлиента.Тонкий1С;
	ЭтоТонкийВеб = ТипКлиента = Перечисления.ТЦТипКлиента.ТонкийВеб;
	ЭтоТонкий = ЭтоТонкий1С Или ЭтоТонкийВеб;
	
	Если (ЭтоВеб Или ЭтоТонкий) И НизкаяСкоростьСоединения Тогда
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "O", "Low", ЭтоLinux);
	КонецЕсли;
	
	Если ИмитироватьЗадержку И ТипКлиента <> Перечисления.ТЦТипКлиента.Веб Тогда
		ФорматЧисла = "ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0";
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "SimulateServerCallDelay",, ЭтоLinux);
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска,, "-Call" + Формат(ЗадержкаВызова, ФорматЧисла), ЭтоLinux);
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска,, "-Send" + Формат(ЗадержкаПередачи, ФорматЧисла), ЭтоLinux);
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска,, "-Receive" + Формат(ЗадержкаПолучения, ФорматЧисла), ЭтоLinux);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрЗапуска) Тогда
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "C", ПараметрЗапуска, ЭтоLinux);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Язык) Тогда
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "L", Язык, ЭтоLinux);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодЛокализации) Тогда
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "VL", КодЛокализации, ЭтоLinux);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ФайлСообщений)
		И ТипКлиента <> Перечисления.ТЦТипКлиента.Веб
		И ТипКлиента <> Перечисления.ТЦТипКлиента.Тонкий1С
		И ТипКлиента <> Перечисления.ТЦТипКлиента.ТонкийВеб Тогда
		
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "Out", ФайлСообщений, ЭтоLinux);
		
		Если НеОчищатьСлужебныеСообщения Тогда
			СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
				ТипКлиента, СтрокаЗапуска,, "-NoTruncate", ЭтоLinux);
		КонецЕсли;
	КонецЕсли;
		
	Если ТипКлиента = Перечисления.ТЦТипКлиента.ТонкийВеб Тогда
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "WS", АдресБраузера, ЭтоLinux);
	КонецЕсли;
	
	Если ТипКлиента = Перечисления.ТЦТипКлиента.ТонкийВеб И
	     ТипПрокси = Перечисления.ТЦТипПрокси.НеИспользовать Тогда
		СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "NoProxy",, ЭтоLinux);
	КонецЕсли;
	
	Если ТипКлиента = Перечисления.ТЦТипКлиента.ТонкийВеб И
	     ТипПрокси = Перечисления.ТЦТипПрокси.УказатьНастройки Тогда
		ЕстьАдрес = ЗначениеЗаполнено(АдресПрокси);
		ЕстьПорт = ЗначениеЗаполнено(ПортПрокси);
		ЕстьПользователь = ЗначениеЗаполнено(ПользовательПрокси);
		ЕстьПароль = ЗначениеЗаполнено(ПарольПрокси);
		
		Если ЕстьАдрес И ЕстьПорт Тогда
			СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
				ТипКлиента, СтрокаЗапуска, "Proxy",, ЭтоLinux);
			
			Если ЕстьАдрес Тогда
				СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
					ТипКлиента, СтрокаЗапуска,, "-PSrv" + АдресПрокси, ЭтоLinux);
			КонецЕсли;
			
			Если ЕстьПорт Тогда
				СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
					ТипКлиента, СтрокаЗапуска,, "-PPort" + Формат(ПортПрокси, "ЧГ=0"), ЭтоLinux);
			КонецЕсли;
			
			Если ЕстьПользователь Тогда
				СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
					ТипКлиента, СтрокаЗапуска,, "-PUser" + ПользовательПрокси, ЭтоLinux);
			КонецЕсли;
			
			Если ЕстьПароль Тогда
				СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
					ТипКлиента, СтрокаЗапуска,, "-PPasswd" + ПарольПрокси, ЭтоLinux);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если (ЭтоВеб Или ЭтоТонкийВеб) И
	     ТипАутентификацииВеб = Перечисления.ТЦТипАутентификацииВеб.ИмяПароль Тогда
		 СтрокаЗапуска = ТЦОбщий.ДобавитьПараметрКлиента(
			ТипКлиента, СтрокаЗапуска, "WSA-",, ЭтоLinux);
	КонецЕсли;
	
		
	Возврат СтрокаЗапуска;
	
КонецФункции // СобратьСтрокуЗапуска()

#КонецЕсли
﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
			
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ТекстОшибки =  НСтр("ru = 'Недостаточно прав для завершения сеанса'");
		ПерейтиКШагуМастера(5);
		Возврат;
	КонецЕсли;
				
	ЗавершитьБезПредупреждения = Константы.ЗавершатьСеансыБезПредупрежденияПоУмолчаниюВМоделиСервиса.Получить();
		
	ПерейтиКШагуМастера(1);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//@skip-warning - НеиспользуемыйМетод - особенность реализации.
&НаКлиенте
Функция ПроверитьВводПароля()
	
	Если ПустаяСтрока(Пароль) Тогда	
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не указан пароль для доступа к сервису'"), ,
			"Пароль");	
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

//@skip-warning - НеиспользуемыйМетод - особенность реализации.
&НаКлиенте
Функция НачатьОтправкуПредупреждений()
			
	Если ЗавершитьБезПредупреждения 
		Или Не ОтправитьПредупрежденияНаСервере(Параметры.НомераСеансов, СообщениеПользователям) Тогда
		ПерейтиКШагуМастера(3);
		ПерейтиНаСледующийШаг();
		Возврат Ложь;	
	КонецЕсли;

	ПодключитьОбработчикОжидания("ПослеВыполненияОтправкиПредупрежденийПользователям", 60, Истина);

	Возврат Истина;
				
КонецФункции

&НаКлиенте
Процедура ПослеВыполненияОтправкиПредупрежденийПользователям() Экспорт
	ПерейтиНаСледующийШаг();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОтправитьПредупрежденияНаСервере(Знач НомераСеансов, Знач СообщениеПользователям)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОповещениеПользователю = Новый Структура();
	ОповещениеПользователю.Вставить(
		"ВидОповещения",
		XMLСтрока(Перечисления.ВидыОповещенийПользователей.ПредупреждениеПриЗавершенииСеанса));
	
	НаименованиеПользователя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Пользователи.ТекущийПользователь(),
		"Наименование");
	ОповещениеПользователю.Вставить("НаименованиеПользователя", НаименованиеПользователя);	 
	
	Если ЗначениеЗаполнено(СообщениеПользователям) Тогда
		ОповещениеПользователю.Вставить("Сообщение", СообщениеПользователям);	 
	КонецЕсли;
	
	ИменаИнтерактивныхПриложений = ОбщегоНазначенияБТС.ИменаИнтерактивныхПриложений();
		
	НомераСеансовИменаПользователей = Новый Соответствие();
	Для Каждого Сеанс Из ПолучитьСеансыИнформационнойБазы() Цикл
		
		Если ИменаИнтерактивныхПриложений.Найти(Сеанс.ИмяПриложения) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
				
		ПользовательСеанса = Сеанс.Пользователь;
		Если ПользовательСеанса = Неопределено Тогда
			Продолжить;	
		КонецЕсли;
		
		ИмяПользователя = ПользовательСеанса.Имя;
		Если Не ЗначениеЗаполнено(ИмяПользователя) Тогда
			Продолжить;
		КонецЕсли;
		
		НомераСеансовИменаПользователей.Вставить(Сеанс.НомерСеанса, ИмяПользователя);
	
	КонецЦикла;
	
	ОбластьДанных = РаботаВМоделиСервиса.ЗначениеРазделителяСеанса();	
	ДоставляемыеОповещения = Новый Массив;	
		
	Для Каждого НомерСеанса Из НомераСеансов Цикл
		
		ИмяПользователя = НомераСеансовИменаПользователей.Получить(НомерСеанса);
		Если Не ЗначениеЗаполнено(ИмяПользователя) Тогда
			Продолжить
		КонецЕсли;
		
		ДоставляемоеОповещение = Новый Структура();
		ДоставляемоеОповещение.Вставить("ОбластьДанных", ОбластьДанных);
		ДоставляемоеОповещение.Вставить("ИмяПользователя", ИмяПользователя);	
		ДоставляемоеОповещение.Вставить("НомерСеанса", НомерСеанса);	
		ДоставляемоеОповещение.Вставить("ОповещениеПользователя", ОповещениеПользователю);
		
		ДоставляемыеОповещения.Добавить(ДоставляемоеОповещение);
				
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ДоставляемыеОповещения) Тогда
		Возврат Ложь;
	КонецЕсли;
		
	ОповещениеПользователейБТС.ДоставитьОповещения(ДоставляемыеОповещения);
	
	Возврат Истина;
	
КонецФункции

//@skip-warning - НеиспользуемыйМетод - особенность реализации.
&НаКлиенте
Функция НачатьЗавершениеСеансов()
							
	ДлительнаяОперация = ЗапуститьЗавершениеСеансовНаСервере(
		Параметры.НомераСеансов,
		Пароль,
		СообщениеПользователям);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПослеЗавершенияСеансов", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеПриЗавершении, ПараметрыОжидания);

	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗапуститьЗавершениеСеансовНаСервере(Знач НомераСеансов, Знач Пароль, Знач СообщениеОтПользователя)
	
	ЧастиТекстаСообщенияПользователям = Новый Массив();
	
	НаименованиеПользователя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Пользователи.ТекущийПользователь(),
		"Наименование");
	ЧастиТекстаСообщенияПользователям.Добавить(СтрШаблон(НСтр("ru = 'Сеанс завершен
		|Пользователь завершивший сеанс: %1'"),
		НаименованиеПользователя));
		 
	Если ЗначениеЗаполнено(СообщениеОтПользователя) Тогда
		ЧастиТекстаСообщенияПользователям.Добавить(СтрШаблон(НСтр("ru = 'Сообщение от пользователя: %1'"), СообщениеОтПользователя));
	КонецЕсли;	
	СообщениеПользователям = СтрСоединить(ЧастиТекстаСообщенияПользователям, Символы.ПС); 
		
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияПроцедуры();
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Завершение сеансов'");

	Возврат ДлительныеОперации.ВыполнитьПроцедуру(
		ПараметрыВыполнения,
		"УдаленноеАдминистрированиеБТССлужебный.ЗавершитьСеансыОбластиДанных",
		НомераСеансов,
		Пароль,
		СообщениеПользователям);
		
КонецФункции

&НаКлиенте
Процедура ПослеЗавершенияСеансов(Результат, ДополнительныеПараметры) Экспорт
		
	Если Результат <> Неопределено И Результат.Статус = "Выполнено" Тогда
		
		Закрыть(КодВозвратаДиалога.ОК);
	
	Иначе
		
		Если Результат = Неопределено Тогда
			ПредставлениеОшибки = НСтр("ru = 'Задание отменено'");
		Иначе
			ПредставлениеОшибки = Результат.ПодробноеПредставлениеОшибки;
		КонецЕсли;
		
		ЗаписатьОшибку(
			НСтр("ru = 'Ошибка завершения сеанса'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
			ПредставлениеОшибки);
		
		ТекстОшибки = НСтр("ru = 'При попытке завершить сеансы произошла ошибка.
		|Проверьте правильность ввода пароля для доступа к сервису, попробуйте позже или обратитесь в службу поддержки сервиса'");
		
		ПерейтиКШагуМастера(5);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьОшибку(ИмяСобытия, ТекстОшибки)
	ПолноеИмяСобытия = НСтр("ru = 'ЗавершениеСеансовВМоделиСервиса'", ОбщегоНазначения.КодОсновногоЯзыка()) + "." + ИмяСобытия;
	ЗаписьЖурналаРегистрации(ПолноеИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	ПерейтиНаСледующийШаг();
	
КонецПроцедуры

&НаКлиенте
Функция ВыполнитьОбработчикПереходаМеждуШагами()
	
	Результат = Истина;
	
	Если ЗначениеЗаполнено(ОбработчикПереходаСТекущегоШага) Тогда
		
		Результат = Вычислить(ОбработчикПереходаСТекущегоШага + "()");
				
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПерейтиКШагуМастера(Знач Шаг)
	
	Сценарий = СценарийМастера();
	
	ОписаниеШага = Сценарий.Найти(Шаг, "НомерШага");
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы[ОписаниеШага.Страница];
	Элементы.ГруппаКомандыСтраницы.ТекущаяСтраница = Элементы[ОписаниеШага.СтраницаКоманд];
	
	ОбработчикПереходаСТекущегоШага = ОписаниеШага.Обработчик;
	ТекущийШаг = Шаг;
	
КонецПроцедуры

&НаСервере
Функция СценарийМастера()
	
	Результат = Новый ТаблицаЗначений();
	
	Результат.Колонки.Добавить("НомерШага", Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("Страница", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("СтраницаКоманд", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Обработчик", Новый ОписаниеТипов("Строка"));
	
	// Ввод пароля
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.НомерШага = 1;
	НоваяСтрока.Страница = Элементы.СтраницаВводПароля.Имя;
	НоваяСтрока.СтраницаКоманд = Элементы.СтраницаКомандыВводДанных.Имя;
	НоваяСтрока.Обработчик = "ПроверитьВводПароля";
		
	// Оповещения пользователей
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.НомерШага = 2;
	НоваяСтрока.Страница = Элементы.СтраницаОповещенияПользователей.Имя;
	НоваяСтрока.СтраницаКоманд = Элементы.СтраницаКомандыВводДанных.Имя;
	НоваяСтрока.Обработчик = "НачатьОтправкуПредупреждений";
	
	// Ожидание оповещения пользователей
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.НомерШага = 3;
	НоваяСтрока.Страница = Элементы.СтраницаОжиданиеОповещенияПользователей.Имя;
	НоваяСтрока.СтраницаКоманд = Элементы.СтраницаКомандыОжидание.Имя;
	НоваяСтрока.Обработчик = "НачатьЗавершениеСеансов";
		
	// Ожидание завершения
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.НомерШага = 4;
	НоваяСтрока.Страница = Элементы.СтраницаОжиданиеЗавершенияСеансов.Имя;
	НоваяСтрока.СтраницаКоманд = Элементы.СтраницаКомандыОжидание.Имя;
	
	// Просмотр ошибки
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.НомерШага = 5;
	НоваяСтрока.Страница = Элементы.СтраницаОшибка.Имя;
	НоваяСтрока.СтраницаКоманд = Элементы.СтраницаКомандыОшибка.Имя;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПерейтиНаСледующийШаг()
	
	ТекущийШагДоВыполненияОбработчика = ТекущийШаг;
	
	Если Не ВыполнитьОбработчикПереходаМеждуШагами() Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущийШаг <> ТекущийШагДоВыполненияОбработчика Тогда
		Возврат;
	КонецЕсли;
	
	ПерейтиКШагуМастера(ТекущийШаг + 1);

КонецПроцедуры

#КонецОбласти



﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ИмяПользователя = ИмяПользователя();
	Элементы.Пользователь.ПодсказкаВвода = ИмяПользователя;
	Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	ВыгружатьФайлыВКаталог = 1;
	Если ИмяПользователя = "" Тогда
		Элементы.Пользователь.Видимость = Ложь;
		Элементы.Пароль.Видимость       = Ложь;
	КонецЕсли;
	
	НачатьПодготовкуПараметровВыполненияВФоне(ЭтотОбъект);
	
	ВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для корректной работы необходим режим тонкого или толстого клиента.'"));
		Отказ = Истина;
		Возврат;
	#КонецЕсли
	
	ЗавершитьПодготовкуПараметровВыполненияВФоне(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(РабочийКаталог) И ЗначениеЗаполнено(РабочийКаталог(ЭтотОбъект)) Тогда
		Состояние(НСтр("ru = 'Очистка каталога временных файлов...'"));
		ОчиститьКаталогВременныхФайлов();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Страница "Анализ модулей".

&НаКлиенте
Процедура ВыгружатьФайлыВКаталогПриИзменении(Элемент)
	ВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиКонфигурацииВФайлыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбора.Заголовок          = НСтр("ru = 'Выберите каталог, в который выгружены файлы конфигурации'");
	ДиалогВыбора.Каталог            = РабочийКаталог(ЭтотОбъект);
	ДиалогВыбора.МножественныйВыбор = Ложь;
	Обработчик = Новый ОписаниеОповещения("КаталогВыгрузкиКонфигурацииВФайлыЗавершениеВыбора", ЭтотОбъект);
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(Обработчик, ДиалогВыбора);
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиКонфигурацииВФайлыОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	#Если НЕ ВебКлиент Тогда
		Каталог = РабочийКаталог(ЭтотОбъект);
		Если Не ЗначениеЗаполнено(Каталог) Тогда
			Возврат;
		КонецЕсли;
		ФайловаяСистемаКлиент.ОткрытьПроводник(Каталог);
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиКонфигурацииВФайлыПриИзменении(Элемент)
	Если ЗначениеЗаполнено(РабочийКаталог) Тогда
		РабочийКаталог = ДобавитьКонечныйРазделительПути(РабочийКаталог);
	Иначе
		ВыгружатьФайлыВКаталог = 1;
	КонецЕсли;
	ВидимостьДоступность();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Исключительно переход по страницам.

&НаКлиенте
Процедура КомандаНазад(Команда)
	ПерейтиКСтранице(-1);
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	Закрыть();
КонецПроцедуры

// Страница "Настройка параметров внедрения".

&НаКлиенте
Процедура Обновить(Команда)
	ВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура РасставитьФрагментыКода(Команда)
	ФоновоеЗаданиеПроцент   = 0;
	ФоновоеЗаданиеСостояние = "";
	ПерейтиКСтранице(+1);
	ПодключитьОбработчикОжидания("ЗапуститьФоновоеЗаданиеКлиент", 0.1, Истина);
КонецПроцедуры

// Страница "Ожидание окончания внедрения".

&НаКлиенте
Процедура ПрерватьВнедрение(Команда)
	ПерейтиКСтранице(-1);
	ПодключитьОбработчикОжидания("ОстановитьФоновоеЗаданиеКлиент", 0.1, Истина);
КонецПроцедуры

// Страница "Просмотр результатов внедрения".

&НаКлиенте
Процедура ЗапуститьКонфигуратор(Команда)
	
#Если Не ВебКлиент Тогда
	
	КомандаЗапуска = Новый Массив;
	КомандаЗапуска.Добавить(КаталогПрограммы() + "1cv8.exe");
	КомандаЗапуска.Добавить("DESIGNER");
	КомандаЗапуска.Добавить("/IBConnectionString");
	КомандаЗапуска.Добавить(СтрокаСоединенияИнформационнойБазы());
	КомандаЗапуска.Добавить("/N");
	КомандаЗапуска.Добавить(Пользователь);
	КомандаЗапуска.Добавить("/P");
	КомандаЗапуска.Добавить(Пароль);
	
	ПараметрыЗапускаПрограммы = ФайловаяСистемаКлиент.ПараметрыЗапускаПрограммы();
	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Ложь;
	
	ФайловаяСистемаКлиент.ЗапуститьПрограмму(КомандаЗапуска, ПараметрыЗапускаПрограммы);
	
#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВидимостьДоступность()
	ТекущаяСтраница = Элементы.Страницы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.СтраницаАнализМодулей Тогда
		ОткрытКонфигуратор = РеквизитФормыВЗначение("Объект").ОткрытКонфигуратор();
		
		Элементы.КнопкаНазад.Видимость = Ложь;
		
		Элементы.КнопкаДалее.Видимость  = Истина;
		Элементы.КнопкаДалее.ИмяКоманды = "РасставитьФрагментыКода";
		Элементы.КнопкаДалее.КнопкаПоУмолчанию = Не ОткрытКонфигуратор;
		
		Элементы.КнопкаОтмена.Видимость  = Истина;
		Элементы.КнопкаОтмена.ИмяКоманды = "КомандаЗакрыть";
		
		Элементы.ГруппаОткрытКонфигуратор.Видимость   = ОткрытКонфигуратор;
		Элементы.ГруппаКонфигурацияИзменена.Видимость = КонфигурацияБазыДанныхИзмененаДинамически() Или КонфигурацияИзменена();
		Элементы.РабочийКаталог.ОтметкаНезаполненного = ?(ВыгружатьФайлыВКаталог, Ложь, Не ЗначениеЗаполнено(РабочийКаталог));
		
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаОжиданиеОкончанияВнедрения Тогда
		Элементы.КнопкаНазад.Видимость = Ложь;
		
		Элементы.КнопкаДалее.Видимость = Ложь;
		
		Элементы.КнопкаОтмена.Видимость  = Истина;
		Элементы.КнопкаОтмена.ИмяКоманды = "ПрерватьВнедрение";
		Элементы.КнопкаОтмена.КнопкаПоУмолчанию = Ложь;
		
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаПросмотрРезультатовВнедрения Тогда
		Элементы.КнопкаНазад.Видимость = Ложь;
		
		Элементы.КнопкаДалее.Видимость = Истина;
		Элементы.КнопкаДалее.ИмяКоманды = "ЗапуститьКонфигуратор";
		Элементы.КнопкаДалее.КнопкаПоУмолчанию = Не РеквизитФормыВЗначение("Объект").ОткрытКонфигуратор();
		
		Элементы.КнопкаОтмена.Видимость  = Истина;
		Элементы.КнопкаОтмена.ИмяКоманды = "КомандаЗакрыть";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСтранице(СдвигИлиСтраница)
	Если ТипЗнч(СдвигИлиСтраница) = Тип("ГруппаФормы") Тогда
		Элементы.Страницы.ТекущаяСтраница = СдвигИлиСтраница;
	ИначеЕсли ТипЗнч(СдвигИлиСтраница) = Тип("Число") Тогда
		ДоступныеСтраницы = Элементы.Страницы.ПодчиненныеЭлементы;
		Индекс = ДоступныеСтраницы.Индекс(Элементы.Страницы.ТекущаяСтраница) + СдвигИлиСтраница;
		Если Индекс < 0 Или Индекс >= ДоступныеСтраницы.Количество() Тогда
			Возврат;
		КонецЕсли;
		Элементы.Страницы.ТекущаяСтраница = ДоступныеСтраницы[Индекс];
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Некорректное значение параметра ""%1"": ""%2"".'"),
			"СдвигИлиСтраница",
			СдвигИлиСтраница);
	КонецЕсли;
	ВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиКонфигурацииВФайлыЗавершениеВыбора(ВыбранныеФайлы, ПараметрыВыполнения) Экспорт
	Если ТипЗнч(ВыбранныеФайлы) <> Тип("Массив") Или ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	РабочийКаталог = ДобавитьКонечныйРазделительПути(ВыбранныеФайлы[0]);
	ВидимостьДоступность();
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДобавитьКонечныйРазделительПути(Знач ПутьКаталога)
	Если ПустаяСтрока(ПутьКаталога) Тогда
		Возврат ПутьКаталога;
	КонецЕсли;
	
	ДобавляемыйСимвол = ПолучитьРазделительПути();
	
	Если СтрЗаканчиваетсяНа(ПутьКаталога, ДобавляемыйСимвол) Тогда
		Возврат ПутьКаталога;
	Иначе
		Возврат ПутьКаталога + ДобавляемыйСимвол;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ЗапуститьФоновоеЗаданиеКлиент()
	Задание = ЗапуститьФоновоеЗадание();
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	НастройкиОжидания.ВыводитьПрогрессВыполнения = Истина;
	НастройкиОжидания.ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ПриОбновленииПрогрессаФоновогоЗадания", ЭтотОбъект);
	НастройкиОжидания.Интервал = 1;
	
	Обработчик = Новый ОписаниеОповещения("ПослеЗавершенияФоновогоЗадания", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Обработчик, НастройкиОжидания);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РабочийКаталог(Форма)
	Если ЗначениеЗаполнено(Форма.РабочийКаталог) Тогда
		Возврат Форма.РабочийКаталог;
	ИначеЕсли СтрНачинаетсяС(Форма.Элементы.РабочийКаталог.ПодсказкаВвода, "<") Тогда
		Возврат "";
	Иначе
		Возврат Форма.Элементы.РабочийКаталог.ПодсказкаВвода;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ЗапуститьФоновоеЗадание()
	ТекущаяСтраница = Элементы.Страницы.ТекущаяСтраница;
	Если ТекущаяСтраница <> Элементы.СтраницаОжиданиеОкончанияВнедрения Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Со страницы ""%1"" невозможно запустить длительную операцию'"),
			ТекущаяСтраница.Имя);
	КонецЕсли;
	
	ПараметрыЗадания = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыЗадания.ОжидатьЗавершение = 0;
	ПараметрыЗадания.НаименованиеФоновогоЗадания = Заголовок;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ВыгружатьФайлыВКаталог", ВыгружатьФайлыВКаталог);
	ПараметрыПроцедуры.Вставить("РабочийКаталог",         РабочийКаталог(ЭтотОбъект));
	Если Элементы.Пользователь.Видимость Тогда
		ПараметрыПроцедуры.Вставить("Пользователь", Пользователь);
		ПараметрыПроцедуры.Вставить("Пароль",       Пароль);
	Иначе
		ПараметрыПроцедуры.Вставить("Пользователь", "");
		ПараметрыПроцедуры.Вставить("Пароль",       "");
	КонецЕсли;
	
	ИмяПроцедуры = РеквизитФормыВЗначение("Объект").Метаданные().ПолноеИмя() + ".МодульОбъекта.Внедрение";
	Задание = ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыЗадания); 
	ИдентификаторЗадания = Задание.ИдентификаторЗадания;
	Возврат Задание;
КонецФункции

&НаКлиенте
Процедура ПриОбновленииПрогрессаФоновогоЗадания(Задание, ДополнительныеПараметры) Экспорт
	Если Задание.Прогресс <> Неопределено Тогда
		ФоновоеЗаданиеПроцент   = Задание.Прогресс.Процент;
		ФоновоеЗаданиеСостояние = Задание.Прогресс.Текст;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗавершенияФоновогоЗадания(Задание, ДополнительныеПараметры) Экспорт
	Активизировать();
	Если Задание = Неопределено Тогда
		ПерейтиКСтранице(-1);
		Возврат;
	КонецЕсли;	
	Если Задание.Статус = "Выполнено" Тогда
		Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжиданиеОкончанияВнедрения Тогда
			ЗагрузитьРезультатВнедрения(Задание.АдресРезультата);
		КонецЕсли;
		ПерейтиКСтранице(+1);
	Иначе
		ПерейтиКСтранице(-1);
		ВызватьИсключение Задание.КраткоеПредставлениеОшибки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОстановитьФоновоеЗаданиеКлиент()
	Если ИдентификаторЗадания <> Неопределено Тогда
		ОстановитьФоновоеЗадание(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОстановитьФоновоеЗадание(ИдентификаторЗадания)
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
КонецПроцедуры

&НаСервере
Процедура ОчиститьКаталогВременныхФайлов()
	Если Не ЗначениеЗаполнено(РабочийКаталог) И ЗначениеЗаполнено(РабочийКаталог(ЭтотОбъект)) Тогда
		ФайловаяСистема.УдалитьВременныйКаталог(РабочийКаталог(ЭтотОбъект));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРезультатВнедрения(АдресРезультата)
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	ТабличныйДокумент = Результат.ТабличныйДокумент;
КонецПроцедуры

#Область ВыполнениеПроцедурыВФоне

&НаСервереБезКонтекста
Процедура НачатьПодготовкуПараметровВыполненияВФоне(Форма)
	ПараметрыВыполненияВФоне = Новый Структура("ЭтоВнешняяОбработка, ИмяОбработки, АдресОбработки, ОбработкаДоступнаССервера");
	
	ОбработкаОбъект = Форма.РеквизитФормыВЗначение("Объект");
	МассивПодстрок = СтрРазделить(ОбработкаОбъект.Метаданные().ПолноеИмя(), ".");
	ПараметрыВыполненияВФоне.ИмяОбработки = МассивПодстрок[1];
	ПараметрыВыполненияВФоне.ЭтоВнешняяОбработка = НРег(МассивПодстрок[0]) = НРег("ВнешняяОбработка");
	Если ПараметрыВыполненияВФоне.ЭтоВнешняяОбработка Тогда
		ПараметрыВыполненияВФоне.ИмяОбработки = ОбработкаОбъект.ИспользуемоеИмяФайла;
		Файл = Новый Файл(ОбработкаОбъект.ИспользуемоеИмяФайла);
		ПараметрыВыполненияВФоне.ОбработкаДоступнаССервера = Файл.Существует();
	Иначе
		ПараметрыВыполненияВФоне.ОбработкаДоступнаССервера = Истина;
	КонецЕсли;
	
	Форма.ПараметрыВыполненияВФоне = ПараметрыВыполненияВФоне;
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПодготовкуПараметровВыполненияВФоне(Форма)
	ПараметрыВыполненияВФоне = Форма.ПараметрыВыполненияВФоне;
	Если ПараметрыВыполненияВФоне.ЭтоВнешняяОбработка И Не ПараметрыВыполненияВФоне.ОбработкаДоступнаССервера Тогда
		#Если Не ВебКлиент Тогда
			ПараметрыВыполненияВФоне.АдресОбработки = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПараметрыВыполненияВФоне.ИмяОбработки), УникальныйИдентификатор);
		#КонецЕсли
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

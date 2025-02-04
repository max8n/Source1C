﻿///////////////////////////////////////////////////////////////////////////////
// ФОРМАТИРОВАНИЕ

// Возвращает имя группы доступа Тест-центра
//
// Возвращаемое значение:
//   Строка
//
Функция ИмяГруппыДоступаТестЦентр() Экспорт

	Возврат "Тест-центр";

КонецФункции // ИмяГруппыДоступаТестЦентр()

// Возвращает полное имя подсистемы Тест-центра для справочника "Идентификаторы объектов метаданных".
//
// Возвращаемое значение:
//   Строка
//
Функция ПолноеИмяПодсистемыТестЦентр() Экспорт

	Возврат "Подсистема.ТестЦентр";

КонецФункции // ИмяГруппыДоступаТестЦентр()

// Разделить строку на составляющие по разделителю и поместить
// части строки в массив
//
// Параметры:
//  РазделяемаяСтрока - Строка, которую нужно разделить
//  Разделитель - Строка, символ разделяющий части строки
//  ПустыеСтроки - Булево, Истина - включать пустые строки в результат,
//                 Ложь - не включать пустые строки в результат
//
// Возвращаемое значение:
//  Массив - части строк
//
Функция РазделитьСтроку(ИсходнаяСтрока, Разделитель, ПустыеСтроки = Ложь) Экспорт
	
	Результат = Новый Массив;
	ДлинаСтроки = СтрДлина(ИсходнаяСтрока);
	ТекущаяСтрока = "";
	
	Для Сч = 1 По ДлинаСтроки Цикл
		
		ТекущийСимвол = Сред(ИсходнаяСтрока, Сч, 1);
		
		Если ТекущийСимвол = Разделитель Тогда
			
			ОбработаннаяСтрока = СокрЛП(ТекущаяСтрока);
			
			Если Не ПустаяСтрока(ОбработаннаяСтрока) Или ПустыеСтроки Тогда
				Результат.Добавить(ОбработаннаяСтрока);
			КонецЕсли;
			
			ТекущаяСтрока = "";
			
		Иначе
			ТекущаяСтрока = ТекущаяСтрока + ТекущийСимвол;
		КонецЕсли;
		
	КонецЦикла;
	
	ОбработаннаяСтрока = СокрЛП(ТекущаяСтрока);
	
	Если Не ПустаяСтрока(ОбработаннаяСтрока) Тогда
		Результат.Добавить(ОбработаннаяСтрока);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // РазделитьСтроку()

// Получает из строки вида "Параметр1=ЗначениеПараметра1;Параметр2=ЗначениеПараметра2" соответстие,
// ключами которого являются имена параметров, а значения — значения параметров
//
// Параметры:
//  РазделяемаяСтрока - Строка параметров
//  Разделитель - Строка, символ разделяющий части строки
//
// Возвращаемое значение:
//  Соответствие
Функция РазложитьСтрокуПараметровВСоответствие(Знач ИсходнаяСтрока, Разделитель = ";") Экспорт
	
	Результат = Новый Соответствие;
	
	ОбычноеЗакрытие = Разделитель;
	ЭкранированноеЗакрытие = """" + Разделитель;
	
	ТекущийКлюч = "";
	ОжидаемоеЗакрытиеСтроки = Разделитель;
	ОстатокСтроки = ИсходнаяСтрока;
	
	ПозицияЗнакаРавно = Найти(ОстатокСтроки, "=");
	Пока ПозицияЗнакаРавно <> 0 Цикл
		
		ТекущийКлюч = Лев(ОстатокСтроки, ПозицияЗнакаРавно - 1);
		ОстатокСтроки = Прав(ОстатокСтроки, СтрДлина(ОстатокСтроки) - ПозицияЗнакаРавно);
		
		Сч = 1;
		ТекущаяСтрока = "";
		ПредыдущийСимвол = "";
		ЭтоПервыйСимволПодстроки = Истина;		
		Пока Сч <= СтрДлина(ОстатокСтроки) Цикл
			
			ТекущийСимвол = Сред(ОстатокСтроки, Сч, 1);
			Если ЭтоПервыйСимволПодстроки Тогда
				ЭтоПервыйСимволПодстроки = Ложь;
				Если ТекущийСимвол = """" Тогда
					ОжидаемоеЗакрытиеСтроки = ЭкранированноеЗакрытие;
					Сч = Сч + 1;
					Продолжить;
				Иначе
					ОжидаемоеЗакрытиеСтроки = ОбычноеЗакрытие;
				КонецЕсли;
			КонецЕсли;
			
			Если ТекущийСимвол = """"
				И ОжидаемоеЗакрытиеСтроки = ЭкранированноеЗакрытие
				И ПредыдущийСимвол = """" Тогда
				ПредыдущийСимвол = "";
				Сч = Сч + 1;
				Продолжить;
			КонецЕсли;
			
			Если ПредыдущийСимвол+ТекущийСимвол = ОжидаемоеЗакрытиеСтроки Тогда
				
				Если ОжидаемоеЗакрытиеСтроки = ЭкранированноеЗакрытие
					И СтрДлина(ТекущаяСтрока) > 0 Тогда
					ТекущаяСтрока = Лев(ТекущаяСтрока, СтрДлина(ТекущаяСтрока) - 1);
				КонецЕсли;
				
				Прервать;
				
			КонецЕсли;
			
			ТекущаяСтрока = ТекущаяСтрока + ТекущийСимвол;
			Если ОжидаемоеЗакрытиеСтроки = ЭкранированноеЗакрытие Тогда
				ПредыдущийСимвол = ТекущийСимвол;
			КонецЕсли;
			
			Сч = Сч + 1;
			
		КонецЦикла;
		
		Результат.Вставить(ТекущийКлюч, ТекущаяСтрока);
		ОстатокСтроки = Прав(ОстатокСтроки, СтрДлина(ОстатокСтроки) - Сч);
		ПозицияЗнакаРавно = Найти(ОстатокСтроки, "=");
		
	КонецЦикла;
	
	Если ОстатокСтроки <> "" Тогда
		Результат.Вставить(ОстатокСтроки, "");
	КонецЕсли;
	
	Возврат Результат;
		
КонецФункции // РазложитьСтрокуВМассивСУчетомЭкранирования()

// Удалить ограничивающие строку кавычки
//
// Параметры:
//  ИсходнаяСтрока - Строка, для которой нужно удалить кавычки
//
// Возвращаемое значение:
//  Строка - строка без ограничивающих ее кавычек
//
Функция УдалитьКавычки(ИсходнаяСтрока) Экспорт
	
	Результат = СокрЛП(ИсходнаяСтрока);
	
	Если Лев(Результат, 1) <> """" Или Прав(Результат, 1) <> """" Тогда
		Возврат Результат;
	КонецЕсли;
	
	Возврат Сред(Результат, 2, СтрДлина(Результат) - 2);
	
КонецФункции // УдалитьКавычки()

// Преобразовать массив в строку
//
// Параметры:
//  Массив - исходный массив
//
// Возвращаемое значение:
//  Строка элементов массива, перечисленные через запятую
//
Функция МассивВСтроку(Массив, Разделитель = ", ", ПередПервым = Ложь) Экспорт
	
	Результат = "";
	
	Для каждого Элемент Из Массив Цикл
		Если ПустаяСтрока(Результат) Тогда
			Если ПередПервым Тогда
				Результат = Разделитель;
			КонецЕсли;
		Иначе
			Результат = Результат + Разделитель;
		КонецЕсли;
		
		Результат = Результат + Элемент;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции // МассивВСтроку()

// Преобразовать структуру или соответствие в читаемую строку
//
// Параметры:
//  ДанныеДляПреобразования - значение типа структура, фиксированная структура или соответствие
//  Глубина - служебная переменная, используется для преобразования вложенных структур и соответствий
//  Отступ - задает отступ для отображения элементов вложенных структур и соответствий 
//
// Возвращаемое значение:
//  Строка элементов массива, перечисленные через запятую
//
Функция ПреобразоватьДанныеВСтроку(ДанныеДляПреобразования, Знач Глубина = 0, Отступ = "     ") Экспорт
	
	СтроковоеПредставление = "";
	
	Если Глубина = 20 Тогда
		Возврат "";
	КонецЕсли;
	
	Если ТипЗнч(ДанныеДляПреобразования) <> Тип("Структура")
		И ТипЗнч(ДанныеДляПреобразования) <> Тип("ФиксированнаяСтруктура")
		И ТипЗнч(ДанныеДляПреобразования) <> Тип("Соответствие")
		И ТипЗнч(ДанныеДляПреобразования) <> Тип("Массив") Тогда
		
		Счетчик = 0;
		Пока Счетчик < Глубина Цикл
			СтроковоеПредставление = СтроковоеПредставление + Отступ;
			Счетчик = Счетчик + 1;
		КонецЦикла;
		
		Возврат СтроковоеПредставление + СокрЛП(ДанныеДляПреобразования);
		
	КонецЕсли;

	ИндексЭлемента = 0;
	Для Каждого ЭлементПакета Из ДанныеДляПреобразования Цикл
		
		ТекущийКлюч = СокрЛП(ИндексЭлемента);
		ТекущееЗначение = ЭлементПакета;
		
		// Для развертывания структур и соответствий
		Если ТипЗнч(ЭлементПакета) = Тип("КлючИЗначение") Тогда
			ТекущийКлюч = СокрЛП(ЭлементПакета.Ключ);
			ТекущееЗначение = ЭлементПакета.Значение;
		КонецЕсли;
		
		Счетчик = 0;
		Пока Счетчик < Глубина Цикл
			СтроковоеПредставление = СтроковоеПредставление + Отступ;
			Счетчик = Счетчик + 1;
		КонецЦикла;
		
		Если ТипЗнч(ТекущееЗначение) = Тип("Структура")
			ИЛИ ТипЗнч(ТекущееЗначение) = Тип("Соответствие")
			ИЛИ ТипЗнч(ТекущееЗначение) = Тип("Массив") Тогда
			
			СтроковоеПредставление = СтроковоеПредставление
									+ ТекущийКлюч
									+ ": (" + СокрЛП(ТекущееЗначение) + "(" + СокрЛП(ТекущееЗначение.Количество()) + "))" + Символы.ПС
									+ ПреобразоватьДанныеВСтроку(ТекущееЗначение, Глубина + 1);
		Иначе
			
			СтроковоеПредставление = СтроковоеПредставление + ТекущийКлюч + ": " + СокрЛП(ТекущееЗначение) + Символы.ПС;
			
		КонецЕсли;
			
		ИндексЭлемента = ИндексЭлемента + 1;
		
	КонецЦикла;
	
	Возврат СтроковоеПредставление;
	
КонецФункции

// Получить структурированные параметры подключения к информационной базе
// на основе строки подключения к ней
//
// Параметры:
//  СтрокаПодключения - Строка, строка подключения к информационной базе
//
// Возвращаемое значение:
//  Структура - результат анализа строки подключения
//
Функция ПолучитьПараметрыПодключения(СтрокаПодключения) Экспорт
	
	СоответствиеПараметров = ТЦОбщий.РазложитьСтрокуПараметровВСоответствие(СтрокаПодключения);
	Возврат СоответствиеПараметров;
	
КонецФункции // ПолучитьПараметрыПодключения()

// Получить имя файла из имени пути
//
// Параметры:
//  Путь - Строка, полный путь
//
// Возвращаемое значение:
//  Строка - имя каталога
//
Функция ИмяФайла(Путь) Экспорт
	
	Длина = СтрДлина(Путь);
	Позиция = Длина;
	
	Пока Позиция > 0 Цикл
		
		ТекущийСимвол = Сред(Путь, Позиция, 1);
		
		Если ТекущийСимвол = "/" Или ТекущийСимвол = "\" Тогда
			Возврат Прав(Путь, Длина - Позиция);
		КонецЕсли;
		
		Позиция = Позиция - 1;
		
	КонецЦикла;
	
	Возврат Путь;
	
КонецФункции // ИмяФайла()

// Получить имя каталога из имени пути
//
// Параметры:
//  Путь - Строка, полный путь
//
// Возвращаемое значение:
//  Строка - имя каталога
//
Функция ИмяКаталога(Путь) Экспорт
	
	Позиция = СтрДлина(Путь);
	
	Пока Позиция > 0 Цикл
		
		ТекущийСимвол = Сред(Путь, Позиция, 1);
		
		Если ТекущийСимвол = "/" Или ТекущийСимвол = "\" Тогда
			Возврат Лев(Путь, Позиция - 1);
		КонецЕсли;
		
		Позиция = Позиция - 1;
		
	КонецЦикла;
	
	Возврат Путь;
	
КонецФункции // ИмяКаталога()

// Получить символ разделителя пути к объекту файловой системы
//
// Параметры:
//  Путь - Строка, путь, содержащий разделитель. Если разделителя нет, то "\"
//
// Возвращаемое значение:
//  Строка - символ разделения элементов пути
//
Функция ОпределитьРазделительПути(Путь) Экспорт
	
	Разделитель = "\";
	
	Если Найти(Путь, "/") <> 0 Тогда
		Разделитель = "/";
	КонецЕсли;
	
	Возврат Разделитель;
	
КонецФункции // ОпределитьРазделительПути()

// Проверить путь на наличие завершающего слеша и если он есть, удалить его
//
// Параметры:
//  Путь - Строка, путь
//
// Возвращаемое значение:
//  Путь - Строка, обработанный путь
//
Функция СкорректироватьПуть(Путь) Экспорт
	
	Перем Разделитель;
	
	ДлинаПути = СтрДлина(Путь);
	
	Если ДлинаПути = 0 Тогда
		Возврат Путь;
	КонецЕсли;
	
	Если Найти(Путь, "/") <> 0 Тогда
		Разделитель = "/";
	ИначеЕсли Найти(Путь, "\") <> 0 Тогда
		Разделитель = "\";
	Иначе
		Возврат Путь;
	КонецЕсли;
	
	Пока ДлинаПути > 0 И Прав(Путь, 1) = Разделитель Цикл
		Путь = Лев(Путь, ДлинаПути - 1);
		ДлинаПути = СтрДлина(Путь);
	КонецЦикла;
	
	Возврат Путь;
	
КонецФункции // СкорректироватьПуть()

// Добавить параметр к строке адреса в формате URL
//
// Параметры:
//  Адрес - Строка, в формате URL, уже содержащая "?"
//  Параметр - Строка, имя параметра
//  Значение - Строка, значение параметра
//
// Возвращаемое значение:
//  Строка - адрес, к которому добавлен указанный параметр
//
Функция ДобавитьПараметрURL(Знач Адрес, Параметр, Значение = Неопределено) Экспорт
	
	ЕстьВопрос = Прав(Адрес, 1) = "?";
	ПервыйПараметр = ЕстьВопрос Или Найти(Адрес, "?") = 0;
	
	Если ЕстьВопрос Тогда
		Адрес = Лев(Адрес, СтрДлина(Адрес) - 1);
	КонецЕсли;
	
	Результат = Адрес + ?(ПервыйПараметр, "?", "&") + Параметр;
	
	Если ЗначениеЗаполнено(Значение) Тогда
		Результат = Результат + "=" + КодироватьСтрокуВURL(Строка(Значение));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ДобавитьПараметрURL()

// Добавить параметр командной строки
//
// Параметры:
//  Команда - Строка, команда, к которой добавляется параметр
//  Параметр - Строка, имя параметра
//  Значение - Строка, значение параметра
//
// Возвращаемое значение:
//  Строка - Команда, содержащая указанный параметр
//
Функция ДобавитьПараметрКоманднойСтроки(Команда, Параметр = Неопределено, Значение = Неопределено, ЭтоLinux) Экспорт
	
	Результат = Команда;
	
	Если ЗначениеЗаполнено(Параметр) Тогда
		Результат = Результат + " /" + Параметр;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Значение) Тогда
		Если ЭтоLinux Тогда
			Результат = Результат + " " + ЭкранироватьСтрокуLinux(Значение);
		Иначе
			Результат = Результат + " " + ЭкранироватьСтроку(Значение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ДобавитьПараметрКоманднойСтроки()

// Добавить параметр к строке запуска клиента
//
// Параметры:
//  ТипКлиента - ПеречислениеСсылка.ТЦТипКлиента
//  Команда - Строка, команда, к которой добавляется параметр
//  Параметр - Строка, имя параметра
//  Значение - Строка, значение параметра
//
// Возвращаемое значение:
//  Строка - Команда, содержащая указанный параметр
//
Функция ДобавитьПараметрКлиента(ТипКлиента, Команда, Параметр, Значение = Неопределено, ЭтоLinux) Экспорт
	
	ВебКлиент = ПредопределенноеЗначение("Перечисление.ТЦТипКлиента.Веб");
	
	Если ТипКлиента = ВебКлиент Тогда
		Возврат ДобавитьПараметрURL(Команда, Параметр, Значение);
	Иначе
		Возврат ДобавитьПараметрКоманднойСтроки(Команда, Параметр, Значение, ЭтоLinux);
	КонецЕсли;
	
КонецФункции // ДобавитьПараметр()

// Добавить параметр разедения
//
// Параметры:
//  Параметры - Строка, строка значений разделителей
//  Значение - Произвольный, значение разделителя
//
// Возвращаемое значение:
//  Строка - Параметр "Параметры", дополненный значением разделителя
//
Функция ДобавитьРазделитель(Знач Параметры, Значение, Используется) Экспорт
	
	Если Не ПустаяСтрока(Параметры) Тогда
		Параметры = Параметры + ",";
	КонецЕсли;
	
	Тип = ТипЗнч(Значение);
	ЗначениеСтр = "";
	
	Если Тип = Тип("Булево") Тогда
		ЗначениеСтр = Формат(Число(Значение), "ЧН=0");
	ИначеЕсли Тип = Тип("Число") Тогда
		ЗначениеСтр = Формат(Значение, "ЧН=0; ЧГ=0");
	ИначеЕсли Тип = Тип("Дата") Тогда
		ЗначениеСтр = Формат(Значение, "ДФ=yyyyMMddHHmmss");
	ИначеЕсли Тип = Тип("Строка") Тогда
		ЗначениеСтр = Значение;
	Иначе
		СсылкаОбработана = Ложь;
		Попытка
			ЗначениеСтр = Формат(Значение.Код, "ЧН=0; ЧГ=0");
			СсылкаОбработана = Истина;
		Исключение
		КонецПопытки;
		Попытка
			ЗначениеСтр = Формат(Значение.Номер, "ЧН=0; ЧГ=0");
			СсылкаОбработана = Истина;
		Исключение
		КонецПопытки;
		Если Не СсылкаОбработана Тогда
			ВызватьИсключение "Значение """ + Значение + """ разделителя имеет неподдерживаемый тип """ + Тип + """";
		КонецЕсли;
	КонецЕсли;
	
	Первый = Лев(ЗначениеСтр, 1);
	
	Если Первый = "+" Или Первый = "-" Тогда
		ЗначениеСтр = Первый + ЗначениеСтр;
	КонецЕсли;
	
	ЗначениеСтр = СтрЗаменить(ЗначениеСтр, ".", "..");
	ЗначениеСтр = СтрЗаменить(ЗначениеСтр, ",", ",,");
	
	Возврат Параметры + ?(Используется, "+", "-") + ЗначениеСтр;
	
КонецФункции // ДобавитьРазделитель()

// Преобразовать соответствие в массив
//
// Параметры:
//  Значения - Массив
//  ИмяКолонки - Строка, имя колонки таблицы значений для массива
//
// Возвращаемое значение:
//  Массив
//
Функция СоответствиеВМассив(Значения) Экспорт
	
	Результат = Новый Массив;
	
	Для каждого Значение Из Значения Цикл
		Результат.Добавить(Значение.Ключ);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции // СоответствиеВМассив()

// Окружить строку кавычками, если она содержит пробелы
//
// Параметры:
//  Текст - Строка, исходная строка
//
// Возвращаемое значение:
//  Строка
//
Функция ЭкранироватьСтроку(Знач Текст) Экспорт
	
	Если Найти(Текст, " ") <> 0 Или Найти(Текст, Символы.НПП) <> 0 Тогда
		Текст = СтрЗаменить(Текст, """", """""");
		Возврат """" + Текст + """";
	Иначе
		Возврат Текст;
	КонецЕсли;
	
КонецФункции // ЭкранироватьСтроку()

// Заменить спецсимволы в строке, для возможности использования в URL
//
// Параметры:
//  Текст - Строка, исходная строка
//
// Возвращаемое значение:
//  Строка
//
Функция ЭкранироватьСтрокуURL(Текст) Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	ВерсияПлатформы = СисИнфо.ВерсияПриложения;
	
	Это82 = Ложь;           
	Если ТЦОбщий.СравнитьВерсии(ВерсияПлатформы, "8.3") < 0 Тогда
		Текст = ТЦОбщий.КодироватьСтрокуURLВURL(Текст);
	Иначе
		Текст = ТЦСервер.КодироватьСтрокуURLВURL(Текст);
	КонецЕсли;
	
	Возврат Текст;

	
КонецФункции // ЭкранироватьСтрокуURL()

// Кодировать строку в URL
//
// Параметры:
//  Текст - Строка, исходная строка
//
// Возвращаемое значение:
//  Строка
//
Функция КодироватьСтрокуВURL(Текст) Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	ВерсияПлатформы = СисИнфо.ВерсияПриложения;
	
	Это82 = Ложь;           
	Если ТЦОбщий.СравнитьВерсии(ВерсияПлатформы, "8.3") < 0 Тогда
		Текст = ТЦОбщий.КодироватьВURL(Текст);
	Иначе
		Текст = ТЦСервер.КодироватьСтрокуВURL(Текст);
	КонецЕсли;
	
	Возврат Текст;
	
КонецФункции // КодироватьСтрокуВURL()

// Кодирует строку URL в URL
//
Функция КодироватьСтрокуURLВURL(Текст) Экспорт
	
	Результат = "";
	Длина = СтрДлина(Текст);
	
	Для Сч = 1 По Длина Цикл
		
		Символ = Сред(Текст, Сч, 1);
		Код = КодСимвола(Символ);
		
		Если ( Код >= КодСимвола("0") И Код <= КодСимвола("9") )
			ИЛИ( Код >= КодСимвола("a") И Код <= КодСимвола("z") ) 
			ИЛИ( Код >= КодСимвола("A") И Код <= КодСимвола("Z") )
			ИЛИ Найти("_(!#$%'()*+,/:;=?@[])", Символ) <> 0 
			Тогда
			
			Результат = Результат + Символ;
			
		Иначе
			
			Если Код <= 127 Тогда
				Результат = Результат + "%" + ПредставлениеЧислаВШестнадцатиричной(Код);
			ИначеЕсли Код <= 2047 Тогда
				ПерваяЧасть = 192 + (Цел( Код/64 ));
				ВтораяЧасть = 128 + (Код % 64);
				Результат = Результат + "%" + ПредставлениеЧислаВШестнадцатиричной(ПерваяЧасть)
									  + "%" + ПредставлениеЧислаВШестнадцатиричной(ВтораяЧасть);
			Иначе
				
				ПерваяЧасть = 224 + (Цел( Код/4096 ));
				Остаток = Цел(Код%4096);
				
				ВтораяЧасть = 128 + (Цел( Остаток/64 ));
				ТретьяЧасть = 128 + (Остаток%64);
				
				Результат = Результат + "%" + ПредставлениеЧислаВШестнадцатиричной(ПерваяЧасть)
									  + "%" + ПредставлениеЧислаВШестнадцатиричной(ВтораяЧасть)
									  + "%" + ПредставлениеЧислаВШестнадцатиричной(ТретьяЧасть);
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Кодирует текст в URL
//
Функция КодироватьВURL(Текст) Экспорт
	
	Результат = "";
	Длина = СтрДлина(Текст);
	
	Для Сч = 1 По Длина Цикл
		
		Символ = Сред(Текст, Сч, 1);
		Код = КодСимвола(Символ);
		
		Если ( Код >= КодСимвола("0") И Код <= КодСимвола("9") )
			ИЛИ( Код >= КодСимвола("a") И Код <= КодСимвола("z") ) 
			ИЛИ( Код >= КодСимвола("A") И Код <= КодСимвола("Z") )
			Тогда
			
			Результат = Результат + Символ;
			
		Иначе
			
			Если Код <= 127 Тогда
				Результат = Результат + "%" + ПредставлениеЧислаВШестнадцатиричной(Код);
			ИначеЕсли Код <= 2047 Тогда
				ПерваяЧасть = 192 + (Цел( Код/64 ));
				ВтораяЧасть = 128 + (Код % 64);
				Результат = Результат + "%" + ПредставлениеЧислаВШестнадцатиричной(ПерваяЧасть)
									  + "%" + ПредставлениеЧислаВШестнадцатиричной(ВтораяЧасть);
			Иначе
				
				ПерваяЧасть = 224 + (Цел( Код/4096 ));
				Остаток = Цел(Код%4096);
				
				ВтораяЧасть = 128 + (Цел( Остаток/64 ));
				ТретьяЧасть = 128 + (Остаток%64);
				
				Результат = Результат + "%" + ПредставлениеЧислаВШестнадцатиричной(ПерваяЧасть)
									  + "%" + ПредставлениеЧислаВШестнадцатиричной(ВтораяЧасть)
									  + "%" + ПредставлениеЧислаВШестнадцатиричной(ТретьяЧасть);
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Заменить спецсимволы в строке, для возможности использования в Linux
//
// Параметры:
//  Текст - Строка, исходная строка
//
// Возвращаемое значение:
//  Строка
//
Функция ЭкранироватьСтрокуLinux(Текст) Экспорт
	
	Результат = СтрЗаменить(Текст, """", "\""");
	Результат = СтрЗаменить(Результат, ";", "\;");
	Результат = СтрЗаменить(Результат, "&", "\&");
	
	Если Найти(Результат, " ") <> 0 Или Найти(Результат, Символы.НПП) <> 0 Тогда
		Результат = """" + Результат + """";
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции // ЭкранироватьСтрокуLinux()

// Записать сообщение
//
// Параметры:
//  
//
Процедура ЗаписатьВЖурнал(Сообщение,
                          Событие = Неопределено,
                          Важность = Неопределено) Экспорт
	
	ЭтоОшибка = ТипЗнч(Сообщение) = Тип("ИнформацияОбОшибке")
	        Или ТипЗнч(Сообщение) = Тип("Структура");
	
	Если ЭтоОшибка Тогда
		ТекстОшибки = ТЦОбщий.ИнформациюОбОшибкеВСтроку(Сообщение);
	Иначе
		ТекстОшибки = Сообщение;
	КонецЕсли;
	
	ТЦСервер.ЗаписатьВЖурнал(
		ТекстОшибки,
		Событие,
		Важность,
		ЭтоОшибка);
	
КонецПроцедуры // ЗаписатьВЖурнал()

// Преобразовать объект типа ИнформацияОбОшибке в строку
//
// Параметры:
//  Ошибка - ИнформацияОбОшибке
//
// Возвращаемое значение:
//  Строка - Строковое предстваление ошибки
//
Функция ИнформациюОбОшибкеВСтроку(Ошибка, НомерПричины = 0) Экспорт
	
	ТекстОшибки = "";
	
	Если Не ПустаяСтрока(Ошибка.ИмяМодуля) Тогда
		ТекстОшибки = ТекстОшибки + "{"
			+ Ошибка.ИмяМодуля + "("
			+ Ошибка.НомерСтроки + ")}: ";
	КонецЕсли;
	
	ТекстОшибки = ТекстОшибки
		+ Ошибка.Описание + "
		|" + Ошибка.ИсходнаяСтрока;
	
	Если Ошибка.Причина <> Неопределено Тогда
		ТекстОшибки = ТекстОшибки + "
			|
			|ПРИЧИНА №" + Формат(НомерПричины + 1, "ЧГ=0") + "
			|" + ИнформациюОбОшибкеВСтроку(Ошибка.Причина, НомерПричины + 1);
	КонецЕсли;
	
	Возврат ТекстОшибки;
	
КонецФункции // ИнформациюОбОшибкеВСтроку()

// Преобразовать ИнформацияОбОшибке в Структуру для возможности сохранения
//
// Параметры:
//  Ошибка - ИнформацияОбОшибке
//
// Возвращаемое значение:
//  Структура - полностью соответствует структуре ИнформацияОбОшибке
//
Функция ИнформациюОбОшибкеВСтруктуру(Ошибка) Экспорт
	
	СтруктураОшибки = Новый Структура;
	СтруктураОшибки.Вставить("ИмяМодуля", Ошибка.ИмяМодуля);
	СтруктураОшибки.Вставить("ИсходнаяСтрока", Ошибка.ИсходнаяСтрока);
	СтруктураОшибки.Вставить("НомерСтроки", Ошибка.НомерСтроки);
	СтруктураОшибки.Вставить("Описание", Ошибка.Описание);
	СтруктураОшибки.Вставить("Причина",
		?(Ошибка.Причина <> Неопределено,
			ИнформациюОбОшибкеВСтруктуру(Ошибка.Причина),
			Неопределено));
	Возврат СтруктураОшибки;
	
КонецФункции // ИнформациюОбОшибкеВСтруктуру()

// Получить имя оригинального пользователя
//
// Параметры:
//  ИмяКлона - Строка, имя клонированной учетной записи
//
// Возвращаемое значение:
//  Строка - имя оригинального пользователя
//
Функция ИмяОригинала(ИмяКлона) Экспорт
	
	ПозицияСуффикса = Найти(ИмяКлона, "_ТЦ");
		
	Если ПозицияСуффикса > 0 Тогда
		Возврат Лев(ИмяКлона, ПозицияСуффикса - 1);
	Иначе
		Возврат ИмяКлона;
	КонецЕсли;
	
КонецФункции // ИмяКлона()

// Функция возвращает имя подсистемы управления доступом БСП
//
// Возвращаемое значение:
//  Строка - имя подсистемы управления доступом
//
Функция БСПИмяПодсистемыУправленияДоступом() Экспорт
	
	Возврат "УправлениеДоступом";
	
КонецФункции

// Скопировать массив
//
// Параметры:
//  ИсходныйМассив - Массив
//
// Возвращаемое значение:
//  Массив - Копия исходного массива
//
Функция СкопироватьМассив(ИсходныйМассив) Экспорт
	
	КопияМассива = Новый Массив;
	
	Для каждого Элемент Из ИсходныйМассив Цикл
		КопияМассива.Добавить(Элемент);
	КонецЦикла;
	
	Возврат КопияМассива;
	
КонецФункции // СкопироватьМассив()

// Формирует параметы выполнения сценария
//
Процедура СформироватьИлиДополнитьПараметрыВыполнения(ПараметрыВыполнения) Экспорт
	
	Если ТипЗнч(ПараметрыВыполнения) <> Тип("Структура") Тогда
		ПараметрыВыполнения = Новый Структура;
	КонецЕсли;
		
	Если НЕ ПараметрыВыполнения.Свойство("НачальноеКоличествоПользователей") Тогда
		ПараметрыВыполнения.Вставить("НачальноеКоличествоПользователей", 0);
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("НачальныйШагДозапускаПользователей") Тогда
		ПараметрыВыполнения.Вставить("НачальныйШагДозапускаПользователей", 0);
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("КонечныйШагДозапускаПользователей") Тогда
		ПараметрыВыполнения.Вставить("КонечныйШагДозапускаПользователей", 0);
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("ПороговыйAPDEX") Тогда
		ПараметрыВыполнения.Вставить("ПороговыйAPDEX", 0);
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("МаксимальноеКоличествоИтераций") Тогда
		ПараметрыВыполнения.Вставить("МаксимальноеКоличествоИтераций", 1);
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("КритическоеКоличествоОшибокИтерации") Тогда
		ПараметрыВыполнения.Вставить("КритическоеКоличествоОшибокИтерации", 1);
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("КритическоеКоличествоОшибокТеста") Тогда
		ПараметрыВыполнения.Вставить("КритическоеКоличествоОшибокТеста", 0);
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("КоличествоОдновременноЗапускаемыхВРМАгента") Тогда
		ПараметрыВыполнения.Вставить("КоличествоОдновременноЗапускаемыхВРМАгента", Неопределено);
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("ОбщееКоличествоОдновременноЗапускаемыхВРМ") Тогда
		ПараметрыВыполнения.Вставить("ОбщееКоличествоОдновременноЗапускаемыхВРМ", Неопределено);
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("ЭтоДинамическийТест") Тогда
		ПараметрыВыполнения.Вставить("ЭтоДинамическийТест", Ложь);
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("РаспределятьПоКомпьютерамРавномерно") Тогда
		ПараметрыВыполнения.Вставить("РаспределятьПоКомпьютерамРавномерно", Ложь);
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("КоэффициентИнтенсивности") Тогда
		ПараметрыВыполнения.Вставить("КоэффициентИнтенсивности", 1);
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("АдресПубликации") Тогда
		ПараметрыВыполнения.Вставить("АдресПубликации", "");
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("ЕстьРазделение") Тогда
		ПараметрыВыполнения.Вставить("ЕстьРазделение", Ложь);
	КонецЕсли;
	
	Если НЕ ПараметрыВыполнения.Свойство("ТаблицаРаспределения") Тогда
		ПараметрыВыполнения.Вставить("ТаблицаРаспределения", Неопределено);
	КонецЕсли;
	
КонецПроцедуры

// Сравнивает версии платформы
//
// Параметры:
//  Версия1  - Строка - первая версия платформы
//  Версия2  - Строка - вторая версия платформы
//
// Возвращаемое значение:
//   Число   - -1, если Версия1 меньше Версия2
//				0, если Версия1 совпадает с Версия2
//				1, если Версия1 больше Версия2
//
Функция СравнитьВерсии(Знач Версия1, Знач Версия2) Экспорт

	Версия1 = СтрЗаменить(Версия1, ".", Символы.ПС);
	Версия2 = СтрЗаменить(Версия2, ".", Символы.ПС);
	
	ОписаниеЧисла = Новый ОписаниеТипов("Число");
	
	Для Сч = 1 По 4 Цикл
		
		Строка1 = СтрПолучитьСтроку(Версия1, Сч);
		Строка2 = СтрПолучитьСтроку(Версия2, Сч);
		
		Число1 = ?(Строка1 = "", 0, ОписаниеЧисла.ПривестиЗначение(Строка1));
		Число2 = ?(Строка2 = "", 0, ОписаниеЧисла.ПривестиЗначение(Строка2));
				
		Если Число1 > Число2 Тогда
			 Возврат 1;
		 ИначеЕсли Число1 < Число2 Тогда
			 Возврат -1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат 0;
	
КонецФункции // СравнитьВерсии()

// Функция - Интервал опроса управления тестированием по умолчанию
// 
// Возвращаемое значение:
//   - Число
//
Функция ИнтервалОпросаУправленияТестированиемПоУмолчанию() Экспорт
	
	Возврат 30;
	
КонецФункции

// Функция - Общее количество одновременно запускаемых ВРМ по умолчанию
// 
// Возвращаемое значение:
//   - Число
//
Функция ОбщееКоличествоОдновременноЗапускаемыхВРМПоУмолчанию() Экспорт
	
	Возврат 0;
	
КонецФункции

// Функция - Количество одновременно запускаемых ВРМАгента по умолчанию
// 
// Возвращаемое значение:
//   - Число
//
Функция КоличествоОдновременноЗапускаемыхВРМАгентаПоУмолчанию() Экспорт
	
	Возврат 10;
	
КонецФункции

// Функция - Таймаут опроса агентов по умолчанию
// 
// Возвращаемое значение:
//   - Число
//
Функция ТаймаутОпросаАгентовПоУмолчанию() Экспорт
	
	Возврат 20;
	
КонецФункции

// Функция - Таймаут запуска клиента по умолчанию
// 
// Возвращаемое значение:
//   - Число
//
Функция ТаймаутЗапускаКлиентаПоУмолчанию() Экспорт
	
	Возврат 60;
	
КонецФункции

// Функция - Таймаут опроса клиента по умолчанию
// 
// Возвращаемое значение:
//   - Число
//
Функция ТаймаутОпросаКлиентаПоУмолчанию() Экспорт
	
	Возврат 60;
	
КонецФункции

// Функция - Таймаут загрузки сценария клиентом по умолчанию
// 
// Возвращаемое значение:
//   - Число
//
Функция ТаймаутЗагрузкиСценарияКлиентомПоУмолчанию() Экспорт
	
	Возврат 60;
	
КонецФункции

// Функция - Таймаут подготовки по умолчанию
// 
// Возвращаемое значение:
//   - Число
//
Функция ТаймаутПодготовкиПоУмолчанию() Экспорт
	
	Возврат 180;
	
КонецФункции

// Функция - Таймаут инициализации по умолчанию
// 
// Возвращаемое значение:
//   - Число
//
Функция ТаймаутИнициализацииПоУмолчанию() Экспорт
	
	Возврат 300;
	
КонецФункции

// Функция - Таймаут выполнения по умолчанию
// 
// Возвращаемое значение:
//   - Число
//
Функция ТаймаутВыполненияПоУмолчанию() Экспорт
	
	Возврат 900;
	
КонецФункции

// Функция - Таймаут записи результатов по умолчанию
// 
// Возвращаемое значение:
//   - Число
//
Функция ТаймаутЗаписиРезультатовПоУмолчанию() Экспорт
	
	Возврат 300;
	
КонецФункции

// Функция - Таймаут удаления данных по умолчанию
// 
// Возвращаемое значение:
//   - Число
//
Функция ТаймаутУдаленияДанныхПоУмолчанию() Экспорт
	
	Возврат 300;
	
КонецФункции


///////////////////////////////////////////////////////////////////////////////
// МАТЕМАТИКА

// Округлить число вверх, т.е. 1.1 до 2.0
//
// Параметры:
//  Значение - Число, округляемое значение
//
// Возвращаемое значение:
//  Число - округленное число
//
Функция ОкрВверх(Значение) Экспорт
	
	Целое = Цел(Значение);
	Возврат Целое + ?(Значение - Целое > 0, 1, 0);
	
КонецФункции // ОкрВверх()

// Возвращает корень переданного значения, используется в общем макете ТЦСКДРезультатыЗамеровПроизводительности82
//
// Параметры:
//  Значение - Число, из которого следует извлечь корень
//
// Возвращаемое значение:
//  Число - корень из переданного значения
//
Функция Корень(Значение) Экспорт
	Возврат SQRT(Значение);
КонецФункции

// Возвращает представление значение в шестнадцатиричной системе
//
Функция ПредставлениеЧислаВШестнадцатиричной(Знач Значение)
	
	Если Значение = 0 Тогда
		Возврат "00";
	КонецЕсли;
	
	Представление = "";
	ПредставлениеЧисел = "0123456789ABCDEF";
	
	Пока Значение > 0 Цикл
		
		Частное = Цел(Значение/16);
		ОстатокОтделения = Значение - 16 * Частное;
		Представление = Сред(ПредставлениеЧисел, 1 + ОстатокОтделения, 1) + Представление;
		Значение = Частное;
		
	КонецЦикла;
	
	Если СтрДлина(Представление) % 2 > 0 Тогда
		Представление = "0" + Представление;
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

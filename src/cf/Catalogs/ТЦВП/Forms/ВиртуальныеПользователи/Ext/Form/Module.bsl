﻿&НаКлиенте
Перем мВыгрузка;
&НаКлиенте
Перем мНачалоВыгрузки;
&НаКлиенте
Перем мУдаляемыеВРМ;

&НаКлиенте
// 
//
// Параметры:
//  
//
Процедура ОжиданиеЗавершенияВыгрузкиВРМ()
	
	Готово = Ложь;
	
	Если ТекущаяДата() - мНачалоВыгрузки < 10 Тогда
		ЗапущеныеАгенты = ТЦСервер.КлиентыЗапущены(мУдаляемыеВРМ);
		
		Если ЗапущеныеАгенты.Количество() = 0 Тогда
			Готово = Истина;
		КонецЕсли;
	Иначе
		ЗапущеныеАгенты = ТЦСервер.КлиентыЗапущены(мУдаляемыеВРМ);
		
		Если ЗапущеныеАгенты.Количество() > 0 Тогда
			ТЦСервер.УдалитьКлиентов(ЗапущеныеАгенты);
		КонецЕсли;
		
		Готово = Истина;
	КонецЕсли;
	
	Если Готово Тогда
		Элементы.Список.Обновить();
		ОтключитьОбработчикОжидания("ОжиданиеЗавершенияВыгрузкиВРМ");
		Элементы.УдалитьВРМ.Заголовок = "Выгрузить";
		мВыгрузка = Ложь;
		УстановитьДоступность();
	КонецЕсли;
	
КонецПроцедуры // ОжиданиеЗавершенияВыгрузкиВРМ()

&НаКлиенте
Процедура УдалитьВРМ(Команда)
	
	Попытка
		ДатаНачала = ТекущаяДата();
		ОтключитьОбработчикОжидания("ОжиданиеЗавершенияВыгрузкиВРМ");
		мУдаляемыеВРМ = ТЦОбщий.СкопироватьМассив(Элементы.Список.ВыделенныеСтроки);
		ТЦСервер.ЗавершитьРаботуВРМ(мУдаляемыеВРМ);
		мНачалоВыгрузки = ТекущаяДата();
		Элементы.УдалитьВРМ.Заголовок = "Выгрузка...";
		мВыгрузка = Истина;
		УстановитьДоступность();
		ПодключитьОбработчикОжидания("ОжиданиеЗавершенияВыгрузкиВРМ", 1);
	Исключение
		Ошибка = ИнформацияОбОшибке();
		ТЦОбщий.ЗаписатьВЖурнал(Ошибка);
		ТЦКлиент.СообщитьОбОшибке(Ошибка, ДатаНачала, ТекущаяДата());
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
// 
//
// Параметры:
//  
//
Процедура УстановитьДоступность()
	
	ПустаяСтрока = Не ЗначениеЗаполнено(Элементы.Список.ТекущаяСтрока);
	Элементы.УдалитьВРМ.Доступность = Не ПустаяСтрока И мВыгрузка <> Истина;
	
КонецПроцедуры // УстановитьДоступность()

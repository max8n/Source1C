﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

// Пример функции, вызываемой в фоне.
Функция РассчитатьЗначение(НомерОперации, ДлительностьРасчета = 10, ЗавершитьСОшибкой = Ложь, ВыводитьПрогрессВыполнения = Ложь) Экспорт
	
	ИмитироватьДлительноеДействие(НомерОперации, ДлительностьРасчета, ВыводитьПрогрессВыполнения);
	
	Если ЗавершитьСОшибкой Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка: расчет %1 не выполнен'"), НомерОперации);
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Расчет %1 выполнен за %2 сек.'"), НомерОперации, ДлительностьРасчета);
	
КонецФункции

// Пример процедуры, вызываемой в фоне.
Процедура ВыполнитьРасчет(НомерОперации, ДлительностьРасчета = 10, ЗавершитьСОшибкой = Ложь, ВыводитьПрогрессВыполнения = Ложь) Экспорт
	
	ИмитироватьДлительноеДействие(НомерОперации, ДлительностьРасчета, ВыводитьПрогрессВыполнения);
	
	Если ЗавершитьСОшибкой Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка: действие %1 не выполнено'"), НомерОперации);
	КонецЕсли;
	
КонецПроцедуры

Процедура ИмитироватьДлительноеДействие(НомерОперации, ДлительностьРасчета, ВыводитьПрогрессВыполнения)
	
	Для Счетчик = 1 По ДлительностьРасчета Цикл
		Пауза(1);
		Процент = Цел(Счетчик / ДлительностьРасчета * 100);
		Этап = Мин(Цел(Счетчик / (ДлительностьРасчета / 3)) + 1, 3); // Имитация операции в 3 этапа.
		
		ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 операция %2 выполнена на %3 % (этап %4)'"),
			ТекущаяДатаСеанса(), НомерОперации, Процент, Этап));
		
		Если ВыводитьПрогрессВыполнения Тогда
			ДлительныеОперации.СообщитьПрогресс(Процент, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Этап %1'"), Этап));
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура Пауза(ИнтервалОжидания)
	ПараметрыЗапуска = ФайловаяСистема.ПараметрыЗапускаПрограммы();
	ПараметрыЗапуска.ДождатьсяЗавершения = Истина;
	ФайловаяСистема.ЗапуститьПрограмму("timeout /t " + Формат(ИнтервалОжидания, "ЧГ=0"), ПараметрыЗапуска);
КонецПроцедуры

#КонецОбласти

#КонецЕсли

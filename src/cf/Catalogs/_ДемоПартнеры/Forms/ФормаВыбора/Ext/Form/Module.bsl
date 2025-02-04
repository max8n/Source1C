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
	
	ОпределитьОтображениеСпискаПартнеров(Параметры.ТолькоСВнешнимДоступом);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОпределитьОтображениеСпискаПартнеров(ТолькоСВнешнимДоступом)
	
	// Проверка на подсистему
	Если ПравоДоступа("Чтение", Метаданные.Справочники.ВнешниеПользователи)
		И ПолучитьФункциональнуюОпцию("ИспользоватьВнешнихПользователей") Тогда
		ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ВЫРАЗИТЬ(ВЫРАЗИТЬ(НЕ ВнешниеПользователи.Ссылка ЕСТЬ NULL КАК БУЛЕВО)
			|			И НЕ ВнешниеПользователи.Недействителен
			|			И НЕ ВнешниеПользователи.ПометкаУдаления КАК БУЛЕВО) КАК ВнешнийДоступ,
			|	Справочник_ДемоПартнеры.Ссылка КАК Ссылка,
			|	Справочник_ДемоПартнеры.Код КАК Код,
			|	Справочник_ДемоПартнеры.Наименование КАК Наименование
			|ИЗ
			|	Справочник._ДемоПартнеры КАК Справочник_ДемоПартнеры
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВнешниеПользователи КАК ВнешниеПользователи
			|		ПО Справочник_ДемоПартнеры.Ссылка = ВнешниеПользователи.ОбъектАвторизации";
		
		Элементы.ВнешнийДоступ.Видимость = Истина;
		
		Если ТолькоСВнешнимДоступом Тогда
			ТекстЗапроса = ТекстЗапроса + "
			| ГДЕ ВЫРАЗИТЬ(НЕ ВнешниеПользователи.Ссылка ЕСТЬ NULL КАК БУЛЕВО)
			| И НЕ ВнешниеПользователи.Недействителен И НЕ ВнешниеПользователи.ПометкаУдаления = ИСТИНА";
		КонецЕсли;
	Иначе	
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
			| Справочник_ДемоПартнеры.Ссылка КАК Ссылка,
			| Справочник_ДемоПартнеры.Код КАК Код,
			| Справочник_ДемоПартнеры.Наименование КАК Наименование
			| ИЗ Справочник._ДемоПартнеры КАК Справочник_ДемоПартнеры";
	КонецЕсли;
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица              = "Справочник._ДемоПартнеры";
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса                 = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
КонецПроцедуры

#КонецОбласти




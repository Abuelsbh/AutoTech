import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

class ExcelService {
  static Future<List<Map<String, dynamic>>> readStudentsFromExcel() async {
    try {
      // اختيار ملف Excel
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        allowMultiple: false,
      );

      if (result == null) {
        throw Exception('لم يتم اختيار ملف');
      }

      // قراءة الملف
      Uint8List? fileBytes = result.files.first.bytes;
      if (fileBytes == null) {
        throw Exception('خطأ في قراءة الملف');
      }

      // تحليل ملف Excel
      var excel = Excel.decodeBytes(fileBytes);
      var sheet = excel.tables[excel.tables.keys.first];

      if (sheet == null) {
        throw Exception('لا توجد جداول في الملف');
      }

      List<Map<String, dynamic>> students = [];

      // تخطي الصف الأول (العناوين)
      for (int row = 1; row < sheet.maxRows; row++) {
        var rowData = sheet.rows[row];
        
        if (rowData.length < 5) continue; // تأكد من وجود 5 أعمدة على الأقل

        // استخراج البيانات من كل عمود
        String idNumber = _getCellValue(rowData[0]) ?? '';
        String name = _getCellValue(rowData[1]) ?? '';
        String classSection = _getCellValue(rowData[2]) ?? '';
        String guardianPhone = _getCellValue(rowData[3]) ?? '';
        String guardianName = _getCellValue(rowData[4]) ?? '';

        // التحقق من صحة البيانات
        if (idNumber.isNotEmpty && name.isNotEmpty) {
          students.add({
            'idNumber': idNumber,
            'name': name,
            'classSection': classSection,
            'guardianPhone': guardianPhone,
            'guardianName': guardianName,
          });
        }
      }

      return students;
    } catch (e) {
      throw Exception('خطأ في قراءة ملف Excel: $e');
    }
  }

  // استخراج الفصول الفريدة من بيانات الطلاب
  static List<String> extractUniqueClassSections(List<Map<String, dynamic>> studentsData) {
    Set<String> uniqueClassSections = {};
    
    for (var student in studentsData) {
      String classSection = student['classSection']?.toString().trim() ?? '';
      if (classSection.isNotEmpty) {
        uniqueClassSections.add(classSection);
      }
    }
    
    return uniqueClassSections.toList();
  }

  static String? _getCellValue(dynamic cell) {
    if (cell == null) return null;
    
    if (cell.value is TextCellValue) {
      return cell.value.toString();
    } else if (cell.value is IntCellValue) {
      return cell.value.toString();
    } else if (cell.value is DoubleCellValue) {
      return cell.value.toString();
    }
    
    return cell.value?.toString();
  }

  static Future<void> downloadStudentsTemplate() async {
    try {
      // إنشاء ملف Excel نموذجي
      var excel = Excel.createExcel();
      var sheet = excel['الطلاب'];

      // إضافة العناوين
      sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('رقم الهوية');
      sheet.cell(CellIndex.indexByString('B1')).value = TextCellValue('اسم الطالب');
      sheet.cell(CellIndex.indexByString('C1')).value = TextCellValue('الصف والشعبة');
      sheet.cell(CellIndex.indexByString('D1')).value = TextCellValue('رقم جوال الوصي');
      sheet.cell(CellIndex.indexByString('E1')).value = TextCellValue('اسم الوصي');

      // إضافة بيانات تجريبية
      sheet.cell(CellIndex.indexByString('A2')).value = TextCellValue('1234567890');
      sheet.cell(CellIndex.indexByString('B2')).value = TextCellValue('أحمد محمد علي');
      sheet.cell(CellIndex.indexByString('C2')).value = TextCellValue('grade1 A');
      sheet.cell(CellIndex.indexByString('D2')).value = TextCellValue('01012345678');
      sheet.cell(CellIndex.indexByString('E2')).value = TextCellValue('محمد علي');

      // حفظ الملف
      var fileBytes = excel.save();
      if (fileBytes != null) {
        // هنا يمكن إضافة منطق لتحميل الملف
        print('تم إنشاء ملف النموذج بنجاح');
      }
    } catch (e) {
      throw Exception('خطأ في إنشاء ملف النموذج: $e');
    }
  }
}

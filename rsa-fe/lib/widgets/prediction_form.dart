import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_config.dart';

class PredictionForm extends StatefulWidget {
  final Function(String datetime, double suhu, double hujan, int kodeCuaca)
  onSubmit;

  const PredictionForm({super.key, required this.onSubmit});

  @override
  State<PredictionForm> createState() => _PredictionFormState();
}

class _PredictionFormState extends State<PredictionForm> {
  final _formKey = GlobalKey<FormState>();
  final _suhuController = TextEditingController();
  final _hujanController = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();
  int _selectedKodeCuaca = 0;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _kodeCuacaOptions = AppConfig.weatherCodes;

  @override
  void dispose() {
    _suhuController.dispose();
    _hujanController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final double suhu = double.parse(_suhuController.text);
      final double hujan = double.parse(_hujanController.text);
      final String datetime = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(_selectedDateTime);

      setState(() {
        _isLoading = true;
      });

      widget.onSubmit(datetime, suhu, hujan, _selectedKodeCuaca);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Input Data Prediksi',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // DateTime Picker
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Tanggal & Waktu'),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime),
                ),
                onTap: _selectDateTime,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              const SizedBox(height: 16),

              // Suhu Input
              TextFormField(
                controller: _suhuController,
                decoration: const InputDecoration(
                  labelText: 'Suhu (°C)',
                  hintText: 'Masukkan suhu dalam Celsius',
                  prefixIcon: Icon(Icons.thermostat),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Suhu tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Curah Hujan Input
              TextFormField(
                controller: _hujanController,
                decoration: const InputDecoration(
                  labelText: 'Curah Hujan (mm)',
                  hintText: 'Masukkan curah hujan dalam mm',
                  prefixIcon: Icon(Icons.water_drop),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Curah hujan tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  final double hujan = double.parse(value);
                  if (hujan < 0) {
                    return 'Curah hujan tidak boleh negatif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Kode Cuaca Dropdown
              DropdownButtonFormField<int>(
                initialValue: _selectedKodeCuaca,
                decoration: const InputDecoration(
                  labelText: 'Kondisi Cuaca',
                  prefixIcon: Icon(Icons.wb_sunny),
                  border: OutlineInputBorder(),
                ),
                items: _kodeCuacaOptions.map((option) {
                  return DropdownMenuItem<int>(
                    value: option['value'],
                    child: Text(option['label']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKodeCuaca = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Prediksi', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }
}

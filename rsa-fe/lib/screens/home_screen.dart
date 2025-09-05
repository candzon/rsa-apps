import 'package:flutter/material.dart';
import '../models/prediction.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import '../widgets/prediction_form.dart';
import '../widgets/prediction_result.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  final ApiService _apiService = ApiService(); // Instance method

  Future<void> _onPredictionSubmit(
    String datetime,
    double suhu,
    double hujan,
    int kodeCuaca,
  ) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Call API untuk prediksi menggunakan instance method
      final result = await _apiService.getPrediction(
        DateTime.parse(datetime),
        suhu,
        hujan, // curah hujan dalam mm
        1013.25, // tekanan udara default
        10.0, // kecepatan angin default
        kodeCuaca,
      );

      // Buat object Prediction
      final prediction = Prediction(
        datetime: datetime,
        suhuC: suhu,
        curahHujanMm: hujan,
        kodeCuaca: kodeCuaca,
        yPred: result['y_pred'],
        unit: result['unit'],
      );

      // Navigate to result screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PredictionResult(
              prediction: prediction,
              onSaveToHistory: () => _saveToHistory(prediction),
              onBackToForm: () => Navigator.pop(context),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveToHistory(Prediction prediction) async {
    try {
      await DatabaseService().insertPrediction(prediction);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prediksi berhasil disimpan ke riwayat'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error menyimpan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediksi RSA'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Icon(Icons.analytics, size: 48, color: Colors.blue.shade600),
                  const SizedBox(height: 8),
                  Text(
                    'Sistem Prediksi RSA',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Masukkan data cuaca untuk memprediksi permintaan RSA',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blue.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            PredictionForm(onSubmit: _onPredictionSubmit),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Memproses prediksi...'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

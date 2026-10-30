import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MasikaApp());
}

class MasikaApp extends StatelessWidget {
  const MasikaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Masika',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B82F6)),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      ),
      home: const ExpensesHomePage(),
    );
  }
}

class Category {
  final String id;
  final String name;
  final Color color;

  const Category({required this.id, required this.name, required this.color});
}

class Expense {
  final String id;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String note;

  Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.note,
  });
}

class Budget {
  final String categoryId;
  final double monthlyLimit;

  const Budget({required this.categoryId, required this.monthlyLimit});
}

class ExpensesHomePage extends StatefulWidget {
  const ExpensesHomePage({super.key});

  @override
  State<ExpensesHomePage> createState() => _ExpensesHomePageState();
}

class _ExpensesHomePageState extends State<ExpensesHomePage> {
  final List<Category> _categories = const [
    Category(id: 'food', name: 'Продукты', color: Color(0xFF4CAF50)),
    Category(id: 'transport', name: 'Транспорт', color: Color(0xFF2196F3)),
    Category(id: 'cafe', name: 'Кафе', color: Color(0xFFFFC107)),
    Category(id: 'housing', name: 'Жилье', color: Color(0xFF9C27B0)),
    Category(id: 'health', name: 'Медицина', color: Color(0xFFE91E63)),
    Category(id: 'entertainment', name: 'Развлечения', color: Color(0xFF00BCD4)),
    Category(id: 'other', name: 'Прочее', color: Color(0xFF607D8B)),
  ];

  final List<Budget> _budgets = const [
    Budget(categoryId: 'food', monthlyLimit: 8000),
    Budget(categoryId: 'transport', monthlyLimit: 3000),
    Budget(categoryId: 'cafe', monthlyLimit: 2000),
    Budget(categoryId: 'housing', monthlyLimit: 25000),
    Budget(categoryId: 'health', monthlyLimit: 3000),
    Budget(categoryId: 'entertainment', monthlyLimit: 5000),
    Budget(categoryId: 'other', monthlyLimit: 3500),
  ];

  final List<Expense> _expenses = [
    Expense(id: '1', amount: 425.0, categoryId: 'food', date: DateTime.now().subtract(const Duration(days: 1)), note: 'Овощи и продукты'),
    Expense(id: '2', amount: 180.0, categoryId: 'transport', date: DateTime.now().subtract(const Duration(days: 2)), note: 'Метро'),
    Expense(id: '3', amount: 640.0, categoryId: 'cafe', date: DateTime.now().subtract(const Duration(days: 3)), note: 'Кофе и ужин'),
    Expense(id: '4', amount: 18500.0, categoryId: 'housing', date: DateTime.now().subtract(const Duration(days: 5)), note: 'Аренда'),
    Expense(id: '5', amount: 2200.0, categoryId: 'health', date: DateTime.now().subtract(const Duration(days: 6)), note: 'Аптека'),
    Expense(id: '6', amount: 900.0, categoryId: 'entertainment', date: DateTime.now().subtract(const Duration(days: 9)), note: 'Кино'),
    Expense(id: '7', amount: 550.0, categoryId: 'food', date: DateTime.now().subtract(const Duration(days: 12)), note: 'Покупка на неделю'),
    Expense(id: '8', amount: 350.0, categoryId: 'other', date: DateTime.now().subtract(const Duration(days: 15)), note: 'Домашние мелочи'),
  ];

  String _selectedPeriod = 'month';

  @override
  Widget build(BuildContext context) {
    final currentMonthTotal = _totalForPeriod(DateTime(DateTime.now().year, DateTime.now().month, 1), DateTime(DateTime.now().year, DateTime.now().month + 1, 0, 23, 59, 59, 999));
    final defaultCategory = _categories.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Masika'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Счетчик расходов',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Итого за месяц',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0).format(currentMonthTotal)}',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _periodChip('day', 'День'),
                          const SizedBox(width: 8),
                          _periodChip('week', 'Неделя'),
                          const SizedBox(width: 8),
                          _periodChip('month', 'Месяц'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _summaryTile(
                      'Расходы сегодня',
                      _totalForPeriod(
                        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59, 999),
                      ),
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _summaryTile(
                      'Самый дорогой месяц',
                      _highestMonthTotal(),
                      Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Статистика по категориям',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 240,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            sections: _buildChartSections(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._categoryBreakdown(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Последние расходы',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _expenses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final expense = _expenses[index];
                  final category = _categories.firstWhere((c) => c.id == expense.categoryId, orElse: () => defaultCategory);

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: category.color.withOpacity(0.15),
                        child: Icon(Icons.attach_money, color: category.color),
                      ),
                      title: Text(category.name),
                      subtitle: Text(
                        '${DateFormat('dd.MM.yyyy').format(expense.date)} • ${expense.note.isNotEmpty ? expense.note : 'Без комментария'}',
                      ),
                      trailing: Text(
                        '-${NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0).format(expense.amount)}',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.redAccent),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddExpenseDialog,
        icon: const Icon(Icons.add),
        label: const Text('Добавить расход'),
      ),
    );
  }

  Widget _periodChip(String value, String label) {
    final isSelected = _selectedPeriod == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedPeriod = value;
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
      labelStyle: TextStyle(color: isSelected ? Theme.of(context).colorScheme.primary : null),
    );
  }

  Widget _summaryTile(String title, double value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0).format(value),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections() {
    final totals = _categoryTotalsForMonth();
    final totalSpend = totals.values.fold<double>(0, (acc, cur) => acc + cur);
    if (totalSpend <= 0) {
      return [
        PieChartSectionData(
          value: 1,
          color: Colors.grey,
          radius: 70,
          title: '0%',
          titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ];
    }

    return totals.entries.map((entry) {
      final category = _categories.firstWhere((c) => c.id == entry.key, orElse: () => _categories.first);
      final ratio = entry.value / totalSpend;
      return PieChartSectionData(
        value: entry.value,
        color: category.color,
        radius: 78,
        title: '${(ratio * 100).round()}%',
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      );
    }).toList();
  }

  List<Widget> _categoryBreakdown() {
    final totals = _categoryTotalsForMonth();
    final totalSpend = totals.values.fold<double>(0, (acc, cur) => acc + cur);

    final rows = totals.entries.map((entry) {
      final category = _categories.firstWhere((c) => c.id == entry.key, orElse: () => _categories.first);
      final value = entry.value;
      final ratio = totalSpend == 0 ? 0.0 : value / totalSpend;
      final budget = _budgets.firstWhere((budget) => budget.categoryId == entry.key, orElse: () => const Budget(categoryId: 'other', monthlyLimit: 0));

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category.name),
                Text(NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0).format(value)),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: ratio == 0 ? 0 : ratio.clamp(0.0, 1.0),
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: category.color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(category.color),
            ),
            const SizedBox(height: 4),
            Text(
              budget.monthlyLimit > 0
                  ? 'Бюджет ${NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0).format(budget.monthlyLimit)}'
                  : 'Без бюджета',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }).toList();

    return rows;
  }

  Map<String, double> _categoryTotalsForMonth() {
    final monthStart = DateTime(DateTime.now().year, DateTime.now().month, 1);
    final monthEnd = DateTime(DateTime.now().year, DateTime.now().month + 1, 0, 23, 59, 59, 999);

    final totals = <String, double>{};
    for (final category in _categories) {
      totals[category.id] = 0;
    }

    for (final expense in _expenses) {
      if (!expense.date.isBefore(monthStart) && !expense.date.isAfter(monthEnd)) {
        totals[expense.categoryId] = (totals[expense.categoryId] ?? 0) + expense.amount;
      }
    }

    return totals;
  }

  double _totalForPeriod(DateTime start, DateTime end) {
    double total = 0;
    for (final expense in _expenses) {
      if (!expense.date.isBefore(start) && !expense.date.isAfter(end)) {
        total += expense.amount;
      }
    }
    return total;
  }

  double _highestMonthTotal() {
    final monthTotals = <DateTime, double>{};

    for (final expense in _expenses) {
      final monthKey = DateTime(expense.date.year, expense.date.month, 1);
      monthTotals[monthKey] = (monthTotals[monthKey] ?? 0) + expense.amount;
    }

    if (monthTotals.isEmpty) {
      return 0;
    }

    final highest = monthTotals.values.reduce((a, b) => a > b ? a : b);
    return highest;
  }

  Future<void> _showAddExpenseDialog() async {
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String selectedCategoryId = _categories.first.id;
    DateTime selectedDate = DateTime.now();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Новый расход'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Сумма'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategoryId,
                      decoration: const InputDecoration(labelText: 'Категория'),
                      items: _categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setStateDialog(() {
                            selectedCategoryId = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Дата: ${DateFormat('dd.MM.yyyy').format(selectedDate)}',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(const Duration(days: 3650)),
                            );
                            if (pickedDate != null) {
                              setStateDialog(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          child: const Text('Выбрать'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(labelText: 'Комментарий'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
                FilledButton(
                  onPressed: () {
                    final parsedAmount = double.tryParse(amountController.text.replaceAll(',', '.'));
                    if (parsedAmount == null || parsedAmount <= 0) {
                      return;
                    }

                    setState(() {
                      _expenses.insert(
                        0,
                        Expense(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          amount: parsedAmount,
                          categoryId: selectedCategoryId,
                          date: selectedDate,
                          note: noteController.text.trim(),
                        ),
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

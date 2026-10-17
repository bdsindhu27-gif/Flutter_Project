import 'package:flutter/material.dart';

void main() {
  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library Management System',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6750A4),
        scaffoldBackgroundColor: const Color(0xFFF5F5FA),
      ),
      home: const LibraryHome(),
    );
  }
}

class Book {
  String title;
  String author;
  String category;
  int quantity;
  int issued;

  Book({
    required this.title,
    required this.author,
    required this.category,
    required this.quantity,
    this.issued = 0,
  });
}

class LibraryHome extends StatefulWidget {
  const LibraryHome({super.key});

  @override
  State<LibraryHome> createState() => _LibraryHomeState();
}

class _LibraryHomeState extends State<LibraryHome> {
  int selectedPage = 0;
  String search = '';

  final List<Book> books = [
    Book(title: 'Flutter in Action', author: 'Eric Windmill',
        category: 'Technology', quantity: 5),
    Book(title: 'Clean Code', author: 'Robert Martin',
        category: 'Programming', quantity: 8),
    Book(title: 'Atomic Habits', author: 'James Clear',
        category: 'Self Help', quantity: 6),
    Book(title: 'The Alchemist', author: 'Paulo Coelho',
        category: 'Fiction', quantity: 4),
  ];

  final List<String> members = [
    'Aarav Sharma',
    'Priya Reddy',
    'Rahul Kumar',
  ];

  final List<Map<String, dynamic>> loans = [];

  @override
  Widget build(BuildContext context) {
    final pages = [
      'Dashboard',
      'Books',
      'Members',
      'Issue & Return',
      'Reports',
    ];

    final views = [
      dashboard(),
      booksPage(),
      membersPage(),
      loansPage(),
      reportsPage(),
    ];

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.of(context).size.width > 750,
            backgroundColor: Colors.white,
            selectedIndex: selectedPage,
            onDestinationSelected: (index) {
              setState(() {
                selectedPage = index;
                search = '';
              });
            },
            leading: const Padding(
              padding: EdgeInsets.all(24),
              child: Icon(Icons.local_library,
                  size: 36, color: Color(0xFF6750A4)),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.menu_book),
                label: Text('Books'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                label: Text('Members'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.swap_horiz),
                label: Text('Issue & Return'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart),
                label: Text('Reports'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(22),
                  child: Text(
                    pages[selectedPage],
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: views[selectedPage],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget heading(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(
              fontSize: 23, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget dashboard() {
    final total = books.fold<int>(0, (sum, b) => sum + b.quantity);
    final issued = books.fold<int>(0, (sum, b) => sum + b.issued);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6750A4), Color(0xFF9988DC)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('WELCOME TO LIBRA',
                  style: TextStyle(color: Colors.white70)),
              SizedBox(height: 12),
              Text('Your Library, Simplified',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 8),
              Text('Manage your books in one place.',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            statCard('Book Titles', books.length, Icons.menu_book),
            statCard('Total Copies', total, Icons.library_books),
            statCard('Books Issued', issued, Icons.bookmark),
            statCard('Available', total - issued, Icons.check_circle),
          ],
        ),
        const SizedBox(height: 25),
        heading('Popular Books', 'Explore your collection'),
        ...books.map((book) => Card(
          color: Colors.white,
          child: ListTile(
            leading: const Icon(Icons.menu_book,
                color: Color(0xFF6750A4)),
            title: Text(book.title),
            subtitle: Text('${book.author} • ${book.category}'),
            trailing: Text('${book.quantity - book.issued} available'),
          ),
        )),
      ],
    );
  }

  Widget statCard(String title, int value, IconData icon) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF6750A4), size: 30),
          const SizedBox(height: 12),
          Text('$value', style: const TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
  Widget booksPage() {
    final filtered = books.where((b) =>
    b.title.toLowerCase().contains(search.toLowerCase()) ||
        b.author.toLowerCase().contains(search.toLowerCase()) ||
        b.category.toLowerCase().contains(search.toLowerCase())
    ).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading('Book Collection', 'Manage your library inventory'),
        TextField(
          onChanged: (v) => setState(() => search = v),
          decoration: const InputDecoration(
            hintText: 'Search books...',
            prefixIcon: Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
        FilledButton.icon(
          onPressed: addBook,
          icon: const Icon(Icons.add),
          label: const Text('Add Book'),
        ),
        const SizedBox(height: 15),
        ...filtered.map((b) => Card(
          color: Colors.white,
          child: ListTile(
            leading: const Icon(Icons.menu_book,
                color: Color(0xFF6750A4)),
            title: Text(b.title),
            subtitle: Text('${b.author} • ${b.category}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${b.quantity - b.issued} available'),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    if (b.issued > 0) {
                      showMessage('Return issued copies before deleting.');
                    } else {
                      setState(() => books.remove(b));
                    }
                  },
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Future<void> addBook() async {
    final title = TextEditingController();
    final author = TextEditingController();
    final category = TextEditingController();
    final quantity = TextEditingController(text: '1');

    final result = await showDialog<Book>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Book'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Book title'),
              ),
              TextField(
                controller: author,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
              TextField(
                controller: category,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: quantity,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Copies'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final count = int.tryParse(quantity.text);
              if (title.text.trim().isEmpty ||
                  author.text.trim().isEmpty ||
                  category.text.trim().isEmpty ||
                  count == null || count < 1) {
                return;
              }

              Navigator.pop(ctx, Book(
                title: title.text.trim(),
                author: author.text.trim(),
                category: category.text.trim(),
                quantity: count,
              ));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() => books.add(result));
      showMessage('Book added successfully!');
    }
  }

  Widget membersPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading('Library Members', 'Manage registered members'),
        FilledButton.icon(
          onPressed: addMember,
          icon: const Icon(Icons.person_add),
          label: const Text('Add Member'),
        ),
        const SizedBox(height: 15),
        ...members.map((m) => Card(
          color: Colors.white,
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(m),
            subtitle: Text(
              '${loans.where((l) => l['member'] == m && l['active'] == true).length} active loans',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                final hasLoans = loans.any(
                      (l) => l['member'] == m && l['active'] == true,
                );

                if (hasLoans) {
                  showMessage('Return this member’s books first.');
                } else {
                  setState(() => members.remove(m));
                }
              },
            ),
          ),
        )),
      ],
    );
  }

  Future<void> addMember() async {
    final name = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Library Member'),
        content: TextField(
          controller: name,
          decoration: const InputDecoration(
            labelText: 'Full name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (name.text.trim().isNotEmpty) {
                Navigator.pop(ctx, name.text.trim());
              }
            },
            child: const Text('Save Member'),
          ),
        ],
      ),
    );

    if (result != null) {
      if (members.contains(result)) {
        showMessage('Member already exists.');
      } else {
        setState(() => members.add(result));
        showMessage('Member added successfully!');
      }
    }
  }

  Widget loansPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading('Issue & Return', 'Track borrowed books'),
        FilledButton.icon(
          onPressed: issueBook,
          icon: const Icon(Icons.add),
          label: const Text('Issue a Book'),
        ),
        const SizedBox(height: 20),
        if (loans.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Text('No borrowing records yet.'),
            ),
          ),
        ...loans.reversed.map((loan) => Card(
          color: Colors.white,
          child: ListTile(
            leading: const Icon(Icons.menu_book),
            title: Text(loan['book'].title),
            subtitle: Text(
              'Member: ${loan['member']} • Due: ${formatDate(loan['due'])}',
            ),
            trailing: loan['active']
                ? TextButton(
              onPressed: () {
                setState(() {
                  loan['active'] = false;
                  loan['book'].issued--;
                });
                showMessage('Book returned successfully!');
              },
              child: const Text('Return'),
            )
                : const Chip(label: Text('Returned')),
          ),
        )),
      ],
    );
  }

  Future<void> issueBook() async {
    final available = books.where(
          (b) => b.quantity > b.issued,
    ).toList();

    if (available.isEmpty || members.isEmpty) {
      showMessage('Add available books and members first.');
      return;
    }

    Book selectedBook = available.first;
    String selectedMember = members.first;
    int days = 14;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, update) => AlertDialog(
          title: const Text('Issue a Book'),
          content: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Book>(
                  value: selectedBook,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Select book'),
                  items: available.map((b) => DropdownMenuItem<Book>(
                    value: b,
                    child: Text(b.title),
                  )).toList(),
                  onChanged: (v) {
                    if (v != null) {
                      update(() => selectedBook = v);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedMember,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Select member'),
                  items: members.map((m) => DropdownMenuItem<String>(
                    value: m,
                    child: Text(m),
                  )).toList(),
                  onChanged: (v) {
                    if (v != null) {
                      update(() => selectedMember = v);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: days,
                  decoration: const InputDecoration(labelText: 'Loan period'),
                  items: [7, 14, 21, 30].map((d) => DropdownMenuItem<int>(
                    value: d,
                    child: Text('$d days'),
                  )).toList(),
                  onChanged: (v) {
                    if (v != null) update(() => days = v);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Confirm Issue'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      if (selectedBook.quantity <= selectedBook.issued) {
        showMessage('No copies available.');
        return;
      }

      setState(() {
        selectedBook.issued++;
        loans.add({
          'book': selectedBook,
          'member': selectedMember,
          'due': DateTime.now().add(Duration(days: days)),
          'active': true,
        });
      });

      showMessage('Book issued successfully!');
    }
  }

  Widget reportsPage() {
    final total = books.fold<int>(0, (s, b) => s + b.quantity);
    final issued = books.fold<int>(0, (s, b) => s + b.issued);
    final returned = loans.where((l) => l['active'] == false).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading('Library Reports', 'Inventory and borrowing statistics'),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            statCard('Book Titles', books.length, Icons.menu_book),
            statCard('Total Copies', total, Icons.library_books),
            statCard('Available', total - issued, Icons.check_circle),
            statCard('Issued', issued, Icons.bookmark),
            statCard('Members', members.length, Icons.people),
            statCard('Returned', returned, Icons.assignment_turned_in),
          ],
        ),
        const SizedBox(height: 25),
        heading('Inventory', 'Availability of each book'),
        ...books.map((b) => Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: b.quantity == 0
                      ? 0
                      : (b.quantity - b.issued) / b.quantity,
                  minHeight: 8,
                ),
                const SizedBox(height: 6),
                Text('${b.quantity - b.issued} of ${b.quantity} available'),
              ],
            ),
          ),
        )),
      ],
    );
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
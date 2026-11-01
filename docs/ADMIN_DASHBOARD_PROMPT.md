HISTORICAL, not a source of truth. See PROJECT_CONTEXT.md

# Admin Dashboard — Build Prompt

Use this prompt to build the **Halbouni Book Store Admin Dashboard** as a **Flutter Web** app.

---

## Project Identity

- **App name:** `halbouni_admin`
- **Package:** `halbouni_admin`
- **Platform:** Flutter Web only (desktop browser)
- **Backend:** Same Supabase project as the consumer app
  - URL: `https://ghzqbleakxfajzfrjudr.supabase.co`
  - Anon Key: `sb_publishable_6vx5rtY8xfgcorArweZ6ZA_gXyhnTMY`
- **Supabase tables:** `products`, `categories`, `book_details`, `orders`, `order_items`

---

## Architecture: Clean Architecture (Feature-First)

This project **strictly follows Clean Architecture** with three layers per feature:

```
lib/
├── core/                          # Shared across all features
│   ├── constant/                  # Colors, text styles, assets, sizes, strings
│   ├── errors/                    # Failure abstract class + ServerFailure
│   ├── exports/                   # Barrel export files (main_exports.dart, ui_exports.dart)
│   ├── routing/                   # GoRouter app_router.dart
│   ├── services/                  # get_it service locator setup
│   ├── use_cases/                 # Abstract UseCase<Type, Param> base class
│   ├── utils/                     # AppConfig, SupabaseConfig
│   └── widgets/                   # Shared reusable widgets (CustomButton, etc.)
│
├── features/                      # One folder per feature
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/            # Data models (extend entities, fromJson/toJson)
│   │   │   └── repos/             # Repo implementations (concrete)
│   │   ├── domain/
│   │   │   ├── entities/          # Pure Dart entities (Equatable)
│   │   │   ├── repos/             # Abstract repo interfaces
│   │   │   └── use_cases/         # Use case classes
│   │   └── presentation/
│   │       ├── manager/           # Cubits + sealed states
│   │       ├── views/             # Pages/screens
│   │       └── widgets/           # Feature-specific widgets
│   │
│   ├── dashboard/                 # Overview stats + charts
│   ├── books/                     # Book CRUD
│   ├── categories/                # Category CRUD
│   └── orders/                    # Order/payment tracking
│
└── main.dart                      # App entry, MultiBlocProvider, Hive init, Supabase init
```

### Layer Rules

| Layer | Contains | Depends on |
|-------|----------|------------|
| **Domain** | Entities, abstract Repos, Use Cases | Nothing (pure Dart) |
| **Data** | Models, Repo implementations, data sources | Domain |
| **Presentation** | Cubits, States, Views, Widgets | Domain (use cases, repos) |

**Dependency rule:** Presentation → Domain ← Data. Domain never imports Data or Presentation.

---

## State Management: flutter_bloc (Cubit)

All state management uses **Cubit** (not raw Bloc). States use **sealed classes**.

### Pattern: Cubit + Sealed States

```dart
// File: features/books/presentation/manager/books_cubit/admin_books_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/book_entity.dart';
import '../../../domain/use_cases/fetch_books_use_case.dart';

part 'admin_books_state.dart';

class AdminBooksCubit extends Cubit<AdminBooksState> {
  final FetchBooksUseCase fetchBooksUseCase;
  final AddBookUseCase addBookUseCase;
  final UpdateBookUseCase updateBookUseCase;
  final DeleteBookUseCase deleteBookUseCase;

  AdminBooksCubit({
    required this.fetchBooksUseCase,
    required this.addBookUseCase,
    required this.updateBookUseCase,
    required this.deleteBookUseCase,
  }) : super(AdminBooksInitial());

  Future<void> fetchBooks() async {
    emit(AdminBooksLoading());
    final result = await fetchBooksUseCase();
    result.fold(
      (failure) => emit(AdminBooksFailure(failure.message)),
      (books) => emit(AdminBooksLoaded(books)),
    );
  }

  Future<void> addBook(BookEntity book) async {
    emit(AdminBooksLoading());
    final result = await addBookUseCase(book);
    result.fold(
      (failure) => emit(AdminBooksFailure(failure.message)),
      (_) => fetchBooks(), // refresh list after add
    );
  }

  Future<void> updatePrice(String bookId, double newPrice) async {
    final result = await updateBookUseCase(UpdateBookParams(id: bookId, price: newPrice));
    result.fold(
      (failure) => emit(AdminBooksFailure(failure.message)),
      (_) => fetchBooks(), // refresh list after update
    );
  }

  Future<void> deleteBook(String bookId) async {
    emit(AdminBooksLoading());
    final result = await deleteBookUseCase(bookId);
    result.fold(
      (failure) => emit(AdminBooksFailure(failure.message)),
      (_) => fetchBooks(), // refresh list after delete
    );
  }
}
```

### Pattern: Sealed States

```dart
// File: features/books/presentation/manager/books_cubit/admin_books_state.dart

part of 'admin_books_cubit.dart';

@immutable
sealed class AdminBooksState {}

final class AdminBooksInitial extends AdminBooksState {}

final class AdminBooksLoading extends AdminBooksState {}

final class AdminBooksLoaded extends AdminBooksState {
  final List<BookEntity> books;
  AdminBooksLoaded(this.books);
}

final class AdminBooksFailure extends AdminBooksState {
  final String message;
  AdminBooksFailure(this.message);
}
```

---

## Entities: Equatable

Entities are pure Dart classes extending `Equatable`. No framework dependencies.

```dart
// File: features/books/domain/entities/book_entity.dart

import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String imageUrl;
  final String categoryName;
  final bool isFeatured;
  final double? rating;
  final String? author;
  final String? isbn;
  final String? publisher;
  final int? pageCount;
  final String? previewLink;
  final DateTime? createdAt;

  const BookEntity({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryName,
    required this.isFeatured,
    this.rating,
    this.author,
    this.isbn,
    this.publisher,
    this.pageCount,
    this.previewLink,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id, name, description, price, imageUrl,
        categoryName, isFeatured, rating, author,
        isbn, publisher, pageCount, previewLink, createdAt,
      ];
}
```

---

## Models: fromJson / toJson

Models extend entities and handle Supabase's `snake_case` → Dart's `camelCase` mapping.

```dart
// File: features/books/data/models/book_model.dart

import '../../domain/entities/book_entity.dart';

class BookModel extends BookEntity {
  const BookModel({
    required super.id,
    required super.name,
    super.description,
    required super.price,
    required super.imageUrl,
    required super.categoryName,
    required super.isFeatured,
    super.rating,
    super.author,
    super.isbn,
    super.publisher,
    super.pageCount,
    super.previewLink,
    super.createdAt,
  });

  /// Supabase returns snake_case JSON. Map it to camelCase entity fields.
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String,
      categoryName: (json['categories'] as Map<String, dynamic>)['name'] as String,
      isFeatured: json['is_featured'] as bool,
      rating: (json['rating'] as num?)?.toDouble(),
      author: json['book_details'] != null
          ? (json['book_details'] as Map<String, dynamic>)['author'] as String?
          : null,
      isbn: json['book_details'] != null
          ? (json['book_details'] as Map<String, dynamic>)['isbn'] as String?
          : null,
      publisher: json['book_details'] != null
          ? (json['book_details'] as Map<String, dynamic>)['publisher'] as String?
          : null,
      pageCount: json['book_details'] != null
          ? (json['book_details'] as Map<String, dynamic>)['page_count'] as int?
          : null,
      previewLink: json['book_details'] != null
          ? (json['book_details'] as Map<String, dynamic>)['preview_link'] as String?
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        'price': price,
        'image_url': imageUrl,
        'is_featured': isFeatured,
        'rating': rating,
        'categories': {'name': categoryName},
        'book_details': {
          if (author != null) 'author': author,
          if (isbn != null) 'isbn': isbn,
          if (publisher != null) 'publisher': publisher,
          if (pageCount != null) 'page_count': pageCount,
          if (previewLink != null) 'preview_link': previewLink,
        },
      };
}
```

---

## Repos: Abstract + Implementation with Either<Failure, T>

### Abstract Repo (Domain Layer)

```dart
// File: features/books/domain/repos/books_repo.dart

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/book_entity.dart';

abstract class BooksRepo {
  Future<Either<Failure, List<BookEntity>>> fetchBooks();
  Future<Either<Failure, BookEntity>> fetchBookById(String id);
  Future<Either<Failure, void>> addBook(BookEntity book);
  Future<Either<Failure, void>> updateBook(String id, Map<String, dynamic> updates);
  Future<Either<Failure, void>> deleteBook(String id);
}
```

### Repo Implementation (Data Layer)

```dart
// File: features/books/data/repos/books_repo_impl.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/book_entity.dart';
import '../../domain/repos/books_repo.dart';
import '../../../../core/errors/failure.dart';
import '../models/book_model.dart';

class BooksRepoImpl implements BooksRepo {
  final SupabaseClient _supabase;

  BooksRepoImpl({required SupabaseClient supabase}) : _supabase = supabase;

  @override
  Future<Either<Failure, List<BookEntity>>> fetchBooks() async {
    try {
      final data = await _supabase
          .from('products')
          .select('*, categories(name), book_details(*)')
          .order('created_at', ascending: false);

      final books = (data as List)
          .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(books);
    } on PostgrestException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addBook(BookEntity book) async {
    try {
      await _supabase.from('products').insert({
        'name': book.name,
        'description': book.description,
        'price': book.price,
        'image_url': book.imageUrl,
        'is_featured': book.isFeatured,
        'rating': book.rating,
        // category_id must be resolved separately
      });
      return right(null);
    } on PostgrestException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBook(String id, Map<String, dynamic> updates) async {
    try {
      await _supabase.from('products').update(updates).eq('id', id);
      return right(null);
    } on PostgrestException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBook(String id) async {
    try {
      await _supabase.from('products').delete().eq('id', id);
      return right(null);
    } on PostgrestException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookEntity>> fetchBookById(String id) async {
    try {
      final data = await _supabase
          .from('products')
          .select('*, categories(name), book_details(*)')
          .eq('id', id)
          .single();
      return right(BookModel.fromJson(data));
    } on PostgrestException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
```

---

## Use Cases

Use cases extend `UseCase<Type, Param>` and sit in the domain layer.

```dart
// File: core/use_cases/use_case.dart

import 'package:dartz/dartz.dart';
import '../errors/failure.dart';

abstract class UseCase<Type, Param> {
  Future<Either<Failure, Type>> call([Param param]);
}

class NoParam {}
```

```dart
// File: features/books/domain/use_cases/fetch_books_use_case.dart

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/use_cases/use_case.dart';
import '../entities/book_entity.dart';
import '../repos/books_repo.dart';

class FetchBooksUseCase extends UseCase<List<BookEntity>, NoParam> {
  final BooksRepo booksRepo;

  FetchBooksUseCase(this.booksRepo);

  @override
  Future<Either<Failure, List<BookEntity>>> call([NoParam? param]) async {
    return await booksRepo.fetchBooks();
  }
}
```

```dart
// File: features/books/domain/use_cases/add_book_use_case.dart

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/use_cases/use_case.dart';
import '../entities/book_entity.dart';
import '../repos/books_repo.dart';

class AddBookUseCase extends UseCase<void, BookEntity> {
  final BooksRepo booksRepo;

  AddBookUseCase(this.booksRepo);

  @override
  Future<Either<Failure, void>> call([BookEntity? param]) async {
    return await booksRepo.addBook(param!);
  }
}
```

```dart
// File: features/books/domain/use_cases/update_price_use_case.dart

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repos/books_repo.dart';

class UpdatePriceParams {
  final String bookId;
  final double newPrice;
  const UpdatePriceParams({required this.bookId, required this.newPrice});
}

class UpdatePriceUseCase extends UseCase<void, UpdatePriceParams> {
  final BooksRepo booksRepo;

  UpdatePriceUseCase(this.booksRepo);

  @override
  Future<Either<Failure, void>> call([UpdatePriceParams? param]) async {
    return await booksRepo.updateBook(param!.bookId, {'price': param.newPrice});
  }
}
```

```dart
// File: features/books/domain/use_cases/delete_book_use_case.dart

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repos/books_repo.dart';

class DeleteBookUseCase extends UseCase<void, String> {
  final BooksRepo booksRepo;

  DeleteBookUseCase(this.booksRepo);

  @override
  Future<Either<Failure, void>> call([String? param]) async {
    return await booksRepo.deleteBook(param!);
  }
}
```

---

## Errors: Failure

```dart
// File: core/errors/failure.dart

abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}
```

---

## Dependency Injection: get_it

```dart
// File: core/services/setup_service_locator.dart

import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/repos/auth_repo_impl.dart';
import '../../features/auth/domain/repos/auth_repo.dart';
import '../../features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import '../../features/books/data/repos/books_repo_impl.dart';
import '../../features/books/domain/repos/books_repo.dart';
import '../../features/categories/data/repos/categories_repo_impl.dart';
import '../../features/categories/domain/repos/categories_repo.dart';
import '../../features/orders/data/repos/orders_repo_impl.dart';
import '../../features/orders/domain/repos/orders_repo.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Auth
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl());
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt.get<AuthRepo>()));

  // Books
  getIt.registerLazySingleton<BooksRepo>(
    () => BooksRepoImpl(supabase: Supabase.instance.client),
  );

  // Categories
  getIt.registerLazySingleton<CategoriesRepo>(
    () => CategoriesRepoImpl(supabase: Supabase.instance.client),
  );

  // Orders
  getIt.registerLazySingleton<OrdersRepo>(
    () => OrdersRepoImpl(supabase: Supabase.instance.client),
  );
}
```

---

## main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/services/setup_service_locator.dart';
import 'core/services/simple_bloc_observer.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ghzqbleakxfajzfrjudr.supabase.co',
    anonKey: 'sb_publishable_6vx5rtY8xfgcorArweZ6ZA_gXyhnTMY',
  );

  setupServiceLocator();
  Bloc.observer = SimpleBlocObserver();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      title: 'Halbouni Admin',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        colorSchemeSeed: const Color(0xffF79201),
      ),
    );
  }
}
```

---

## Routing: GoRouter

```dart
// File: core/routing/app_router.dart

import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/views/auth_login_view.dart';
import '../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../features/books/presentation/views/books_list_view.dart';
import '../../features/books/presentation/views/add_book_view.dart';
import '../../features/books/presentation/views/edit_book_view.dart';
import '../../features/categories/presentation/views/categories_view.dart';
import '../../features/orders/presentation/views/orders_view.dart';

abstract class AppRouter {
  static const kLogin = '/login';
  static const kDashboard = '/dashboard';
  static const kBooks = '/books';
  static const kAddBook = '/books/add';
  static const kEditBook = '/books/edit/:id';
  static const kCategories = '/categories';
  static const kOrders = '/orders';

  static final GoRouter router = GoRouter(
    initialLocation: kLogin,
    routes: [
      GoRoute(path: kLogin, builder: (_, __) => const AuthLoginView()),
      GoRoute(path: kDashboard, builder: (_, __) => const DashboardView()),
      GoRoute(path: kBooks, builder: (_, __) => const BooksListView()),
      GoRoute(path: kAddBook, builder: (_, __) => const AddBookView()),
      GoRoute(
        path: kEditBook,
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return EditBookView(bookId: id);
        },
      ),
      GoRoute(path: kCategories, builder: (_, __) => const CategoriesView()),
      GoRoute(path: kOrders, builder: (_, __) => const OrdersView()),
    ],
  );
}
```

---

## Supabase Tables

Run these in the Supabase SQL editor to create the new admin tables:

```sql
-- Orders table
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  total DECIMAL NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'cancelled', 'refunded')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Order items table
CREATE TABLE order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id),
  quantity INT NOT NULL,
  price DECIMAL NOT NULL
);

-- RLS policies for admin
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Admin can do everything (check user metadata for role)
CREATE POLICY "Admins can manage orders" ON orders
  FOR ALL USING (
    auth.jwt() ->> 'role' = 'admin'
  );

CREATE POLICY "Admins can manage order_items" ON order_items
  FOR ALL USING (
    auth.jwt() ->> 'role' = 'admin'
  );

-- Existing tables: products, categories, book_details already have anon SELECT policies
-- Add admin INSERT/UPDATE/DELETE policies:
CREATE POLICY "Admins can manage products" ON products
  FOR ALL USING (auth.jwt() ->> 'role' = 'admin');

CREATE POLICY "Admins can manage categories" ON categories
  FOR ALL USING (auth.jwt() ->> 'role' = 'admin');

CREATE POLICY "Admins can manage book_details" ON book_details
  FOR ALL USING (auth.jwt() ->> 'role' = 'admin');
```

---

## Dependencies: pubspec.yaml

```yaml
name: halbouni_admin
description: "Halbouni Book Store Admin Dashboard"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.7.2

dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_bloc: ^9.1.1
  bloc: ^9.2.0
  meta: ^1.16.0

  # Backend
  supabase_flutter: ^2.12.4
  dartz: ^0.10.1
  equatable: ^2.0.8

  # DI
  get_it: ^9.2.1

  # Routing
  go_router: ^17.0.0

  # UI — admin-specific
  data_table_2: ^2.5.8        # Better DataTable for web
  fl_chart: ^0.69.0           # Charts (revenue, orders)
  file_picker: ^8.0.0         # Image upload for book covers
  intl: ^0.20.2               # Date formatting
  csv: ^5.1.0                 # Export payments to CSV
  cached_network_image: ^3.4.1 # Book cover images
  font_awesome_flutter: ^10.9.1

  # UI — shared with consumer app
  flutter_screenutil: ^5.9.3
  flutter_svg: ^2.2.0

  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

---

## Admin Features — Full Spec

### 1. Auth (Login)

- Email + password login form
- After login, check `auth.jwt() ->> 'role' == 'admin'`
- If not admin, show error and sign out
- If admin, navigate to `/dashboard`
- Use `AuthCubit` with states: Initial, Loading, Success, Failure

### 2. Dashboard (Overview)

- **Stats cards:** Total books, Total orders, Total revenue, Pending orders
- **Revenue chart:** Last 7 days revenue bar chart (`fl_chart`)
- **Recent orders:** Last 5 orders in a small table
- Use `DashboardCubit` that calls Supabase `.rpc()` or aggregate queries

### 3. Books Management

- **Books List View:** DataTable with columns: Image, Name, Category, Price, Rating, Actions (Edit/Delete)
- **Search bar:** Filter books by name
- **Add Book View:** Form with fields: Name, Description, Price, Category (dropdown), Is Featured (toggle), Author, ISBN, Publisher, Page Count, Image URL
- **Edit Book View:** Same form pre-filled with existing data, only update changed fields
- **Delete:** Confirmation dialog → delete from Supabase → refresh list
- **Inline price edit:** Click price cell → edit in place → save on blur/enter

### 4. Categories Management

- **Categories List:** Simple DataTable with Name, Actions
- **Add Category:** Text input → insert into `categories` table
- **Edit Category:** Inline edit or modal
- **Delete:** Confirmation → delete (check if books exist in this category first)

### 5. Orders / Payments

- **Orders List:** DataTable with: Order ID, User ID, Total, Status (badge), Date, Actions
- **Status filter:** Dropdown to filter by pending/paid/cancelled/refunded
- **Date range filter:** Filter orders by date range
- **Status update:** Click status badge → dropdown to change status
- **Export to CSV:** Button to download orders as CSV file
- Use `OrdersCubit` with states: Initial, Loading, Loaded, Failure

---

## Conventions to Follow

| Convention | Rule |
|------------|------|
| **Comments** | Do NOT add comments unless explicitly asked |
| **Error handling** | All repo methods return `Either<Failure, T>`, wrapped in try/catch |
| **State pattern** | Sealed classes: Initial, Loading, Loaded/Success, Failure |
| **Entity pattern** | Extend `Equatable`, list all fields in `props` |
| **Model pattern** | Extend entity, add `fromJson` (snake_case → camelCase) and `toJson` |
| **DI** | `getIt.registerLazySingleton` for repos, `getIt.registerFactory` for cubits |
| **Naming** | Feature folders lowercase, files snake_case, classes PascalCase |
| **Imports** | Use relative imports within features, absolute imports for cross-feature |
| **Supabase queries** | Always use `.select('*, categories(name), book_details(*)')` for JOINs |
| **Supabase errors** | Catch `PostgrestException` separately, then generic `catch (e)` |

---

## Expected File Structure When Complete

```
halbouni_admin/
├── lib/
│   ├── core/
│   │   ├── constant/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text_styles.dart
│   │   │   ├── app_constants.dart
│   │   │   └── supabase_config.dart
│   │   ├── errors/
│   │   │   └── failure.dart
│   │   ├── exports/
│   │   │   ├── main_exports.dart
│   │   │   └── ui_exports.dart
│   │   ├── routing/
│   │   │   └── app_router.dart
│   │   ├── services/
│   │   │   ├── setup_service_locator.dart
│   │   │   └── simple_bloc_observer.dart
│   │   ├── use_cases/
│   │   │   └── use_case.dart
│   │   ├── utils/
│   │   │   └── app_config.dart
│   │   └── widgets/
│   │       └── custom_button.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/repos/auth_repo_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/auth_entity.dart
│   │   │   │   └── repos/auth_repo.dart
│   │   │   └── presentation/
│   │   │       ├── manager/auth_cubit/
│   │   │       │   ├── auth_cubit.dart
│   │   │       │   └── auth_state.dart
│   │   │       └── views/auth_login_view.dart
│   │   │
│   │   ├── dashboard/
│   │   │   ├── data/repos/dashboard_repo_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/dashboard_stats.dart
│   │   │   │   ├── repos/dashboard_repo.dart
│   │   │   │   └── use_cases/fetch_stats_use_case.dart
│   │   │   └── presentation/
│   │   │       ├── manager/dashboard_cubit/
│   │   │       │   ├── dashboard_cubit.dart
│   │   │       │   └── dashboard_state.dart
│   │   │       ├── views/dashboard_view.dart
│   │   │       └── widgets/
│   │   │           ├── stat_card.dart
│   │   │           ├── revenue_chart.dart
│   │   │           └── recent_orders_table.dart
│   │   │
│   │   ├── books/
│   │   │   ├── data/
│   │   │   │   ├── models/book_model.dart
│   │   │   │   └── repos/books_repo_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/book_entity.dart
│   │   │   │   ├── repos/books_repo.dart
│   │   │   │   └── use_cases/
│   │   │   │       ├── fetch_books_use_case.dart
│   │   │   │       ├── add_book_use_case.dart
│   │   │   │       ├── update_price_use_case.dart
│   │   │   │       └── delete_book_use_case.dart
│   │   │   └── presentation/
│   │   │       ├── manager/books_cubit/
│   │   │       │   ├── admin_books_cubit.dart
│   │   │       │   └── admin_books_state.dart
│   │   │       ├── views/
│   │   │       │   ├── books_list_view.dart
│   │   │       │   ├── add_book_view.dart
│   │   │       │   └── edit_book_view.dart
│   │   │       └── widgets/
│   │   │           ├── books_data_table.dart
│   │   │           └── book_form.dart
│   │   │
│   │   ├── categories/
│   │   │   ├── data/
│   │   │   │   ├── models/category_model.dart
│   │   │   │   └── repos/categories_repo_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/category_entity.dart
│   │   │   │   ├── repos/categories_repo.dart
│   │   │   │   └── use_cases/
│   │   │   └── presentation/
│   │   │       ├── manager/categories_cubit/
│   │   │       ├── views/categories_view.dart
│   │   │       └── widgets/
│   │   │
│   │   └── orders/
│   │       ├── data/
│   │       │   ├── models/order_model.dart
│   │       │   └── repos/orders_repo_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/order_entity.dart
│   │       │   ├── repos/orders_repo.dart
│   │       │   └── use_cases/
│   │       └── presentation/
│   │           ├── manager/orders_cubit/
│   │           ├── views/orders_view.dart
│   │           └── widgets/
│   │               ├── orders_data_table.dart
│   │               └── status_badge.dart
│   │
│   └── main.dart
│
├── assets/
│   └── images/
├── pubspec.yaml
└── docs/
```

---

*This prompt is self-contained. The agent building the admin app should follow every pattern above exactly.*

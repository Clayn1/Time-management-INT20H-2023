import 'package:dartz/dartz.dart';
import 'package:deltaplan/core/error/failures.dart';

typedef Json = Map<String, dynamic>;
typedef FutureFailable<T> = Future<Either<Failure, T>>;
typedef Failable<T> = Either<Failure, T>;

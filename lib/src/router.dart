import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarea/pages/cita.dart';
import 'package:tarea/pages/agenda.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AgendaPage(),
    ),
    GoRoute(
      path: '/cita',
      builder: (context, state) => CitaPage(
        docID: state.extra != null ? (state.extra as Map)['docID'] : null,
        initialNote:
            state.extra != null ? (state.extra as Map)['initialNote'] : null,
        initialCentro:
            state.extra != null ? (state.extra as Map)['initialCentro'] : null,
        initialEstado:
            state.extra != null ? (state.extra as Map)['initialEstado'] : null,
        initialImportante: state.extra != null
            ? (state.extra as Map)['initialImportante']
            : null,
      ),
    ),
  ],
);

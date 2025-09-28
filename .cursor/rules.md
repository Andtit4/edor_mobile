# 🚀 Rules for Cursor AI

## 🎯 Objectif
Ces règles doivent guider l'IA pour qu'elle :
- Analyse en profondeur **tout mon code**, backend et frontend.
- Propose des solutions **propres, sécurisées et performantes**.
- Respecte mon **architecture existante** et mes conventions de code.
- Génère des fonctionnalités prêtes à l’emploi, sans bug et faciles à maintenir.

---

## 🛠️ Stack & Conventions
- **Backend** : [nestJS, mysql]
- **Frontend** : flutter
- **Architecture** : Clean code / DDD modulaire
- **Qualité du code** :
  - TypeScript strict activé (`"strict": true`)
  - Respect des conventions ESLint/Prettier
  - Nommer les variables et fonctions de manière claire et explicite
  - Utiliser l’injection de dépendances plutôt que du code couplé

---

## 🧠 Analyse & Compréhension
- Toujours **analyser le code existant avant de proposer du nouveau code**.
- Vérifier les imports, types et dépendances avant de générer du code.
- Si une fonctionnalité existe partiellement, **la compléter plutôt que la recréer**.
- Me prévenir si une amélioration est possible pour optimiser performances, sécurité ou architecture.

---

## 📦 Production de Code
- Générer du code **modulaire et réutilisable**.
- Ajouter des **commentaires utiles** (uniquement quand nécessaire, pas de sur-commentaire).
- Respecter les bonnes pratiques de mon stack (ex: services NestJS, repository pattern).
- Toujours tester le code généré (au moins mentalement) avant de le proposer.

---

## 🛡️ Sécurité & Performances
- Ne jamais exposer de données sensibles côté client.
- Utiliser les bonnes pratiques de validation (DTO, Zod, class-validator).
- Optimiser les requêtes SQL pour éviter les N+1 et réduire la charge serveur.
- Proposer un code scalable pour gérer de grandes charges.

---

## 💬 Communication
- Si une information manque, **poser une question avant de générer du code**.
- Toujours expliquer brièvement les choix techniques dans la réponse.

---

## ✅ Exemples de bonnes pratiques
- **Pour une nouvelle API** : générer le controller, le service, le DTO, les tests unitaires.
- **Pour une feature frontend** : inclure la gestion des erreurs et le loading state.
- **Pour un refactoring** : expliquer les bénéfices avant de proposer la modification.

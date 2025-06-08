#!/bin/bash
# Script to clean, get dependencies, and generate localizations in Flutter

set -e

echo "Running flutter clean..."
flutter clean

echo "Running flutter pub get..."
flutter pub get

echo "Running flutter gen-l10n..."
flutter gen-l10n

echo "Running flutter pub get..."
flutter pub get

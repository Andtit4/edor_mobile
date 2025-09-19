-- Script SQL pour mettre à jour les URLs d'images existantes
-- Exécuter ces requêtes dans votre client MySQL

-- Mettre à jour les URLs dans la table users
UPDATE users 
SET profileImage = REPLACE(profileImage, 'http://192.168.100.34:3000', 'http://185.97.146.99:8090') 
WHERE profileImage LIKE 'http://192.168.100.34:3000%';

-- Mettre à jour les URLs dans la table prestataires
UPDATE prestataires 
SET profileImage = REPLACE(profileImage, 'http://192.168.100.34:3000', 'http://185.97.146.99:8090') 
WHERE profileImage LIKE 'http://192.168.100.34:3000%';

-- Mettre à jour les URLs dans la table service_requests (photos)
UPDATE service_requests 
SET photos = REPLACE(photos, 'http://192.168.100.34:3000', 'http://185.97.146.99:8090') 
WHERE photos LIKE '%http://192.168.100.34:3000%';

-- Mettre à jour les URLs dans la table service_requests (clientImage)
UPDATE service_requests 
SET clientImage = REPLACE(clientImage, 'http://192.168.100.34:3000', 'http://185.97.146.99:8090') 
WHERE clientImage LIKE 'http://192.168.100.34:3000%';

-- Vérifier les résultats
SELECT 'users' as table_name, COUNT(*) as count FROM users WHERE profileImage LIKE 'http://185.97.146.99:8090%'
UNION ALL
SELECT 'prestataires' as table_name, COUNT(*) as count FROM prestataires WHERE profileImage LIKE 'http://185.97.146.99:8090%'
UNION ALL
SELECT 'service_requests_photos' as table_name, COUNT(*) as count FROM service_requests WHERE photos LIKE '%http://185.97.146.99:8090%'
UNION ALL
SELECT 'service_requests_client' as table_name, COUNT(*) as count FROM service_requests WHERE clientImage LIKE 'http://185.97.146.99:8090%';

const http = require('http');

const options = {
    hostname: 'localhost',
    port: 3000,
    path: '/prestataires',
    method: 'GET',
    headers: {
        'Content-Type': 'application/json'
    }
};

const req = http.request(options, (res) => {
    console.log(`Status: ${res.statusCode}`);
    console.log(`Headers: ${JSON.stringify(res.headers)}`);

    let data = '';
    res.on('data', (chunk) => {
        data += chunk;
    });

    res.on('end', () => {
        try {
            const prestataires = JSON.parse(data);
            console.log('\n=== PRESTATAIRES ENRICHIS ===');
            prestataires.forEach((prestataire, index) => {
                console.log(`\n--- Prestataire ${index + 1} ---`);
                console.log(`Nom: ${prestataire.firstName} ${prestataire.lastName}`);
                console.log(`Email: ${prestataire.email}`);
                console.log(`Note: ${prestataire.rating}/5`);
                console.log(`Nombre d'avis: ${prestataire.reviewCount}`);
                console.log(`Travaux terminés: ${prestataire.completedJobs}`);
                console.log(`Catégorie: ${prestataire.category}`);
                console.log(`Disponible: ${prestataire.isAvailable}`);
            });
        } catch (error) {
            console.error('Erreur lors du parsing JSON:', error);
            console.log('Données brutes:', data);
        }
    });
});

req.on('error', (error) => {
    console.error('Erreur de requête:', error);
});

req.end();
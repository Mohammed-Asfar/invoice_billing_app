const {GoogleAuth} = require('google-auth-library');
const https = require('https');

const sa = JSON.parse(process.env.FIREBASE_SA);
const version = process.env.APP_VERSION;
const downloadUrl = process.env.DOWNLOAD_URL;
const releaseNotes = process.env.RELEASE_NOTES || 'Bug fixes and improvements';

async function main() {
  const auth = new GoogleAuth({
    credentials: sa,
    scopes: ['https://www.googleapis.com/auth/datastore'],
  });
  const client = await auth.getClient();
  const token = await client.getAccessToken();

  const body = JSON.stringify({
    fields: {
      latestVersion: { stringValue: version },
      downloadUrl: { stringValue: downloadUrl },
      releaseNotes: { stringValue: releaseNotes },
      forceUpdate: { booleanValue: false },
    },
  });

  const url = `https://firestore.googleapis.com/v1/projects/billing-app-db/databases/(default)/documents/app_config/version?updateMask.fieldPaths=latestVersion&updateMask.fieldPaths=downloadUrl&updateMask.fieldPaths=releaseNotes&updateMask.fieldPaths=forceUpdate`;

  const res = await fetch(url, {
    method: 'PATCH',
    headers: {
      Authorization: `Bearer ${token.token}`,
      'Content-Type': 'application/json',
    },
    body,
  });

  const data = await res.json();
  if (res.ok) {
    console.log(`Updated Firestore: version=${version}`);
  } else {
    console.error('Firestore update failed:', JSON.stringify(data));
    process.exit(1);
  }
}

main();

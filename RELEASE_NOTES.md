## What's New in v1.1.0

- **Financial Year Invoice Format**: New invoice numbering system (e.g. 26-27/001) that follows the Indian financial year (April–March)
- **Cloudinary Image Uploads**: Company logo uploads now use Cloudinary instead of Firebase Storage
- **In-App Update Notifications**: The app now checks for updates on launch and shows a dialog with release notes and download link
- **Firebase Migration**: All invoice and quotation data fully migrated from MongoDB to Firebase Firestore
- **CI/CD Pipeline**: Automated release workflow with GitHub Actions for Firestore version updates
- **Bug Fixes**: Fixed invoice list not loading due to int/double type cast issue

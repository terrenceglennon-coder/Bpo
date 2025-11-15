/**
 * Telegram File Handler Node
 *
 * This Code node should be placed immediately after the Telegram Trigger
 * to properly handle file downloads from Telegram servers.
 *
 * Place this BEFORE the "Detect File Type" node
 */

const items = $input.all();

return items.map(item => {
  const message = item.json.message;

  // Initialize result
  let fileId = null;
  let fileName = null;
  let mimeType = null;
  let fileSize = 0;

  // Handle document files (PDFs, etc.)
  if (message.document) {
    fileId = message.document.file_id;
    fileName = message.document.file_name || `document_${Date.now()}`;
    mimeType = message.document.mime_type || 'application/octet-stream';
    fileSize = message.document.file_size || 0;
  }
  // Handle photo files
  else if (message.photo && message.photo.length > 0) {
    // Get the highest resolution photo (last in array)
    const photo = message.photo[message.photo.length - 1];
    fileId = photo.file_id;
    fileName = `photo_${Date.now()}.jpg`;
    mimeType = 'image/jpeg';
    fileSize = photo.file_size || 0;
  }
  // No supported file found
  else {
    throw new Error('No supported file found. Please send an image or PDF document.');
  }

  // Check file size (Telegram bot API limit is 20MB)
  const maxSize = 20 * 1024 * 1024; // 20MB in bytes
  if (fileSize > maxSize) {
    throw new Error(`File too large (${(fileSize / 1024 / 1024).toFixed(2)}MB). Maximum size is 20MB.`);
  }

  return {
    json: {
      ...item.json,
      telegram_file_id: fileId,
      telegram_file_name: fileName,
      telegram_mime_type: mimeType,
      telegram_file_size: fileSize,
      chat_id: message.chat.id,
      message_id: message.message_id,
      user_id: message.from.id,
      user_name: message.from.first_name + (message.from.last_name ? ' ' + message.from.last_name : ''),
      timestamp: new Date(message.date * 1000).toISOString()
    }
  };
});

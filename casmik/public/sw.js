// Maa Ambika Service Worker for Web Push & Mobile System Drawer Notifications
self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(self.clients.claim());
});

// Handle incoming push messages
self.addEventListener('push', (event) => {
  let data = {};
  if (event.data) {
    try {
      data = event.data.json();
    } catch {
      data = { title: 'Maa Ambika Notification', body: event.data.text() };
    }
  }

  const title = data.title || 'Maa Ambika Alert';
  const options = {
    body: data.body || data.shortDetails || 'New update received',
    icon: '/assets/images/app_logo.png',
    badge: '/assets/images/app_logo.png',
    vibrate: [200, 100, 200],
    data: data,
    tag: data.tag || 'maa-ambika-notif',
    renotify: true,
  };

  event.waitUntil(self.registration.showNotification(title, options));
});

// Handle notification tap / click from mobile drawer or desktop tray
self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const role = event.notification.data?.targetRole;
  let targetUrl = '/';
  if (role === 'admin') targetUrl = '/admin';
  else if (role === 'partner') targetUrl = '/partner';
  else if (role === 'delivery') targetUrl = '/delivery';

  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      for (const client of clientList) {
        if (client.url.includes(targetUrl) && 'focus' in client) {
          return client.focus();
        }
      }
      if (self.clients.openWindow) {
        return self.clients.openWindow(targetUrl);
      }
    })
  );
});

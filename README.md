# UAS Topik Khusus TRPL 3A 2025 - Kelompok 1

## 📖 Deskripsi

Project ini merupakan tugas akhir untuk mata kuliah **Topik Khusus** semester genap 2025, kelas **TRPL 3A**. Tema yang diangkat adalah **E-Commerce Toko Sepatu**, yang dikembangkan oleh **Kelompok 1**.

---

## 🚀 Tech Stack

- **Nuxt** (Frontend)
- **Tailwind CSS** (Styling)
- **Express.js** (Backend API)
- **PostgreSQL** (Database)
- **Redis** (Cache & Session Store)
- **RabbitMQ** (Message Broker)
- **Midtrans** (Payment Gateway)
- **Elasticsearch** (Product Search Engine)
- **Google OAuth** (Authentication)

---

## 👥 Tim Pengembang

- Baghaztra Van Ril (Project Leader)
- Firman Ardiansyah (Backend Developer)
- Aditya Ahmad Alfarison (Frontend Developer)
- Muhammad Amir Shafwan (Backend Developer)
- Sultan Maulana Ichiro (Frontend Developer)

---

## How To Run
Prerequisites:
- Docker

```bash
git pull https://github.com/Baghaztra-Van-Ril/uas-toko-sepatu.git

cd uas-toko-sepatu

git submodule update --init --recursive

docker compose up -d --build
```

- Pastikan setiap submodule memiliki .env.prod
- Buka browser dan akses `http://localhost`.

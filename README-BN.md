# Rabix Style — Starter E-commerce Theme (বাংলা)

এই প্যাকেজে আছে:
- মোবাইল-ফার্স্ট কালো/সাদা/লাল স্টোরফ্রন্ট
- প্রোডাক্ট গ্রিড, সার্চ, ক্যাটাগরি, কার্ট
- COD চেকআউট এবং WhatsApp-এ অর্ডার পাঠানোর ব্যবস্থা
- Supabase যুক্ত করার জন্য কনফিগ ফাইল
- Admin login, product management, order status dashboard
- Supabase schema SQL

## আগে জেনে নিন
এটি একটি কার্যকর starter theme, কিন্তু live business চালুর আগে Supabase config, admin-only policies, image storage, order validation, spam protection এবং end-to-end পরীক্ষা সম্পন্ন করতে হবে। GitHub Pages শুধুই static frontend host করে; backend কাজ Supabase-এ হবে।

## ধাপ ১ — GitHub-এ ফাইল প্রকাশ
1. GitHub-এ লগইন করে `rabix-style-store` নামে একটি নতুন **Public repository** তৈরি করুন।
2. এই ZIP extract করে সব ফাইল repository-র root-এ upload করুন: `index.html`, `admin.html`, `styles.css`, `admin.css`, `config.js`, `store.js`, `admin.js`, `supabase-schema.sql`, `README-BN.md`।
3. Repository → Settings → Pages → Build and deployment-এ `Deploy from a branch`, Branch `main`, Folder `/ (root)` নির্বাচন করে Save দিন।
4. GitHub প্রদত্ত `https://USERNAME.github.io/rabix-style-store/` লিংকে সাইট পরীক্ষা করুন।

## ধাপ ২ — Supabase তৈরি
1. https://supabase.com/ এ account খুলে নতুন project তৈরি করুন।
2. SQL Editor খুলে `supabase-schema.sql` ফাইলের SQL কপি করে Run করুন।
3. Authentication → Users থেকে নিজের admin user তৈরি করুন।
4. Project Settings → API থেকে Project URL এবং publishable/anon key কপি করুন।
5. `config.js` ফাইলে `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `WHATSAPP_NUMBER`, `FACEBOOK_URL` বসান। WhatsApp নম্বর country code-সহ digits only, যেমন `8801XXXXXXXXX`।
6. `config.js`-এ কখনো `service_role` key বা অন্য secret key রাখবেন না।

## নিরাপত্তা — লাইভ করার আগে বাধ্যতামূলক
শুধু `authenticated` ব্যবহারকারীকে admin ধরে নেওয়া যথেষ্ট নয়। এই starter SQL-এ authenticated users-এর product/order management policy প্রাথমিক নমুনা হিসেবে রাখা হয়েছে। Production-এ যাওয়ার আগে নির্দিষ্ট admin user-কে `app_metadata`/admin role দিয়ে যাচাই করে policies সীমাবদ্ধ করুন, যাতে সাধারণ authenticated account কোনোভাবেই admin না হতে পারে। Public order insert policy-ও শুধু ক্লায়েন্টের পাঠানো subtotal/total পরীক্ষা করে; বাস্তব পণ্যের দাম ও স্টক server-side Edge Function/RPC-এ পুনরায় যাচাই করুন। Spam/rate limiting ও ফোন নম্বর যাচাই যুক্ত করুন।

## ধাপ ৩ — ডোমেইন সংযোগ
1. GitHub repository → Settings → Pages → Custom domain-এ `rabixstyle.top` লিখে Save করুন।
2. ডোমেইন রেজিস্ট্রারের DNS প্যানেলে GitHub Pages-এর বর্তমান অফিসিয়াল নির্দেশনা অনুসারে apex A/AAAA records অথবা `www` CNAME সেট করুন।
3. DNS যাচাই শেষ হলে Enforce HTTPS চালু করুন। DNS propagation-এ সময় লাগতে পারে।

## সীমাবদ্ধতা ও নোট
- প্রোডাক্টের demo data প্রথমবার দেখা যাবে; Supabase-এ products যোগ হলে লাইভ ডেটা ব্যবহার হবে।
- Admin page Supabase authentication ছাড়া কাজ করবে না।
- এই সংস্করণে product image URL ফিল্ড আছে; Supabase Storage upload UI পরের iteration-এ যুক্ত করা উচিত।
- অর্ডার ডেটাবেসে insert সফল হলে WhatsApp খুলবে; insert ব্যর্থ হলে সাইট তবু WhatsApp খোলার চেষ্টা করে। তাই কাস্টমারকে অর্ডার নিশ্চিত করার আগে ডেটাবেসে অর্ডার আছে কি না পরীক্ষা করুন।
- ডেমো প্রোডাক্টের দাম/স্টক উদাহরণ; নিজের বাস্তব তথ্য দিয়ে প্রতিস্থাপন করুন।

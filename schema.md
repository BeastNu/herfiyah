# حِرفيّة — هيكلة قاعدة البيانات (v1)

> المبدأ: **Parent-Child** — كل كيان رئيسي يقدر يتوسع لأطفال تحته بدون كسر النظام.

## 👪 User (الأب الأساسي — كل أحد بالمنصة)

```
User
├── id             (UUID)
├── name
├── phone
├── email
├── role           [client | provider | admin]
├── created_at
└── updated_at
```

## 🏪 ProviderProfile (يمتد User — role=provider)

```
ProviderProfile
├── id
├── brand_name
├── bio
├── logo_url
├── city / neighborhood
├── is_verified
├── is_active
├── created_at / updated_at
│
├── 👤 TeamMember          ← الفريق (Child)
│   ├── id
│   ├── provider_id
│   ├── name, photo_url, bio
│   ├── is_main_artist     ← صاحبة البزنس نفسها؟
│   ├── is_active
│   └── created_at
│
├── 📍 Location            ← الاستوديو / خدمة منزلية (Child)
│   ├── id
│   ├── provider_id
│   ├── type               [studio | home_service]
│   ├── name               "الاستوديو الرئيسي"
│   ├── address, neighborhood, city
│   ├── travel_fee         ← رسوم التنقل (خدمة منزلية)
│   └── is_active
│
├── 🛍️ Service             ← الخدمات (Child)
│   ├── id
│   ├── provider_id
│   ├── team_member_id     ← مين يقدمها؟ (اختياري)
│   ├── category_id        ← Category
│   ├── name, description
│   ├── duration_minutes
│   ├── studio_price       ← سعر بالاستوديو
│   ├── home_service_price ← سعر بالمنزل (أعلى عادة)
│   ├── is_active
│   └── created_at
│
├── 🖼️ PortfolioItem       ← معرض الأعمال (Child)
│   ├── id
│   ├── provider_id
│   ├── team_member_id     ← من صاحب العمل؟ (اختياري)
│   ├── image_url
│   ├── description
│   └── created_at
│
└── 📅 Availability        ← التوفر (Child)
    ├── id
    ├── provider_id
    ├── team_member_id     ← مين المتاح؟
    ├── location_id        ← وين؟ (null = منزل)
    ├── day_of_week        [0-6]
    ├── start_time / end_time
    ├── is_recurring
    └── created_at
```

## 🏷️ Category (الفئات — مفتوح لأي مهنة)

```
Category
├── id
├── name                "ميكب", "رموش", "أظافر", "تصوير", "رسم"
├── slug
├── is_active
└── parent_id           ← null = فئة رئيسية (يدعم فئات فرعية)
```

> ملاحظة: مفتوح لأي مهنة لا تتطلب ترخيص رسمي — نضيف فئات جديدة بدون كسر النظام.

## 📋 Booking (الحجز — الجسر)

```
Booking
├── id
├── booking_number      ← رقم حجز واضح للعميلة (مثال: HF-1042)
├── client_id           ← العميلة
├── provider_id         ← البزنس
├── team_member_id      ← مين راح يشتغل؟ (أساسي أو نائبة)
├── service_id          ← أي خدمة
├── location_id         ← استوديو ولا منزل؟
├── scheduled_date / time
├── studio_price / home_service_price   ← السعر المتفق عند الحجز
├── travel_fee
├── deposit_amount      ← العربون
├── deposit_percent     ← نسبته وقت الحجز
├── is_alternative_ok   ← العميلة وافقت على بديل؟ (إذا الأساسية مشغولة)
├── status              [pending | confirmed | completed | cancelled | no_show]
├── client_notes
└── created_at / updated_at
```

## ⭐ Review (التقييم — بعد الحجز المكتمل فقط)

```
Review
├── id
├── booking_id          ← حجز مكتمل فقط
├── client_id
├── provider_id
├── team_member_id      ← مين اتقيّم؟
├── rating              [1-5]
├── comment
└── created_at
```

## 💬 Message (الشات — داخل التطبيق)

```
Message
├── id
├── conversation_id
├── sender_id
├── body
├── created_at
└── read_at
```

```
Conversation
├── id
├── client_id
├── provider_id
├── booking_id          ← (اختياري) شات مرتبط بحجز
└── created_at
```

## 💳 Payment (الدفع)

```
Payment
├── id
├── booking_id
├── client_id
├── provider_id
├── amount
├── type               [deposit | full | refund]
├── gateway            [moyasar | paytabs | tap]
├── gateway_ref        ← رقم العملية عند البوابة
├── status             [pending | paid | failed | refunded]
└── created_at
```

---

## 🔗 العلاقات (أهم شيء)

```
User 1──1 ProviderProfile (role=provider)
ProviderProfile 1──N TeamMember
ProviderProfile 1──N Location
ProviderProfile 1──N Service
ProviderProfile 1──N PortfolioItem
ProviderProfile 1──N Availability
Category 1──N Service
Booking N──1 Client (User)
Booking N──1 Provider (User)
Booking N──1 TeamMember
Booking N──1 Service
Booking N──1 Location
Booking 1──1 Review (بعد المكتمل)
Booking 1──N Payment (عربون + الباقي)
```

---

## 📌 قرارات مؤجلة (نرجع لها بعد MVP)

- [ ] نسبة العربون (ثابتة على المنصة؟ ولا كل مزودة تحدد؟)
- [ ] سياسة الإلغاء والاسترجاع التفصيلية
- [ ] التسعير (عمولة المنصة / خطة الفريق)
- [ ] الشكل القانوني
- [ ] الهوية البصرية (اسم، لوجو، ألوان)

# Bochs WASM PoC - Runtime ISO Boot

این پروژه یک Proof of Concept برای اجرای Bochs x86-64 emulator در محیط WebAssembly است که امکان دریافت ISO خارجی در Runtime را فراهم می‌کند.

## معماری

```
External ISO → JavaScript → WASM → Bochs CD-ROM → BIOS → Boot → Framebuffer
```

## فایل‌های خروجی

- `bochs_x64.wasm` - هسته اصلی emulator (2.8 MB)
- `bochs_x64.js` - JavaScript bridge برای ارتباط با WASM
- `index.html` - نمونه HTML برای تست

## ویژگی‌ها

✅ **Single-threaded** - بدون نیاز به pthreads
✅ **بدون SharedArrayBuffer** - قابل اجرا در Android WebView
✅ **x86-64 support** - پشتیبانی از دستورالعمل‌های 64 بیتی
✅ **Runtime ISO loading** - دریافت ISO از JavaScript در زمان اجرا
✅ **CD-ROM boot** - قابلیت بوت از CD-ROM مجازی
✅ **nogui display** - خروجی متنی برای سادگی

## نحوه استفاده

1. فایل‌های زیر را آماده کنید:
   - `BIOS-bochs-latest` (از پوشه bochs-src/bochs/bios/)
   - `VGABIOS-lgpl-latest` (از پوشه bochs-src/bochs/bios/)
   - یک فایل ISO کوچک برای تست (مثل FreeDOS)

2. `index.html` را در یک سرور محلی اجرا کنید:
   ```bash
   python3 -m http.server 8080
   ```

3. مرورگر را باز کنید و به آدرس `http://localhost:8080/poc-test/` بروید

4. فایل‌های BIOS، VGABIOS و ISO را انتخاب کرده و دکمه "Start Bochs" را بزنید

## ساخت Bochs WASM

```bash
cd /workspace/bochs-wasm-poc

# نصب Emscripten
cd emsdk && ./emsdk install 3.1.40 && ./emsdk activate 3.1.40
source ./emsdk_env.sh

# Build Bochs
mkdir build-bochs && cd build-bochs
emconfigure ../bochs-src/bochs/configure \
  --host wasm32-unknown-emscripten \
  --enable-x86-64 \
  --with-nogui \
  --enable-usb --enable-usb-ehci \
  --disable-large-ramfile --disable-show-ips --disable-stats \
  --disable-logging \
  --enable-repeat-speedups --enable-fast-function-calls \
  --disable-trace-linking --enable-handlers-chaining --enable-avx

CFLAGS="-O2 -s WASM=1 -s ASYNCIFY=1 -s ALLOW_MEMORY_GROWTH=1 \
  -s TOTAL_MEMORY=$((30*1024*1024)) -sNO_EXIT_RUNTIME=1 \
  -sFORCE_FILESYSTEM=1 -D__GNU__" \
CXXFLAGS="${CFLAGS}" \
emmake make -j$(nproc) bochs
```

## وضعیت فعلی

### ✅ تأیید شده (VERIFIED)

1. **bochs_x64.wasm ساخته شد** - فایل WASM با موفقیت کامپایل شد (2.8 MB)
2. **bochs_x64.js ساخته شد** - فایل JavaScript bridge موجود است (110 KB)
3. **Single-threaded** - هیچ reference به pthread یا SharedArrayBuffer وجود ندارد
4. **x86-64 support** - با فلگ `--enable-x86-64` build شده است
5. **WASM معتبر** - هدر فایل `00 61 73 6d` (magic number WASM)

### ⚠️ نیاز به تست بیشتر (UNVERIFIED)

1. **ISO خارجی در Runtime** - مکانیزم JS → FS.writeFile آماده است، اما نیاز به تست واقعی دارد
2. **CD-ROM recognition** - driver CD-ROM در Bochs موجود است، نیاز به تست دارد
3. **BIOS boot از CD-ROM** - تنظیمات bochsrc آماده است، نیاز به تست دارد
4. **Framebuffer output** - با nogui display، خروجی فعلاً متنی است
5. **Android WebView** - تئوریاً باید کار کند (بدون SharedArrayBuffer)، نیاز به تست دارد

## محدودیت‌ها

- فعلاً فقط نمایش متنی (nogui) - برای VGA framebuffer نیاز به توسعه بیشتر است
- سرعت emulation پایین است (مناسب برای PoC)
- حافظه اولیه 30 MB تنظیم شده است

## قدم‌های بعدی

1. تست واقعی با FreeDOS ISO
2. اضافه کردن پشتیبانی از VGA framebuffer
3. بهینه‌سازی سرعت emulation
4. تست در Android WebView

## منابع

- Bochs fork: https://github.com/ktock/Bochs/tree/c2w-wasm
- container2wasm: https://github.com/container2wasm/container2wasm

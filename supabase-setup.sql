-- =============================================
-- Kayan Store Attendance System — Supabase Setup
-- شغّل الكود ده في Supabase > SQL Editor
-- =============================================

-- Sellers
CREATE TABLE IF NOT EXISTS sellers (
  id         UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name       TEXT NOT NULL,
  code       TEXT NOT NULL UNIQUE,
  password   TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Attendance
CREATE TABLE IF NOT EXISTS attendance (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  seller_code   TEXT NOT NULL,
  employee_name TEXT NOT NULL,
  action        TEXT NOT NULL CHECK (action IN ('حضور','انصراف','غياب')),
  note          TEXT,
  recorded_at   TIMESTAMPTZ DEFAULT now(),
  date          DATE DEFAULT CURRENT_DATE
);

-- Shift Handovers
CREATE TABLE IF NOT EXISTS shift_handovers (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  seller_code   TEXT NOT NULL,
  employee_name TEXT NOT NULL,
  status        TEXT NOT NULL CHECK (status IN ('ok','nok')),
  note          TEXT,
  recorded_at   TIMESTAMPTZ DEFAULT now(),
  date          DATE DEFAULT CURRENT_DATE
);

-- Tasks
CREATE TABLE IF NOT EXISTS tasks (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  seller_code   TEXT NOT NULL,
  employee_name TEXT NOT NULL,
  task_text     TEXT NOT NULL,
  status        TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','done')),
  note          TEXT,
  completed_at  TIMESTAMPTZ,
  recorded_at   TIMESTAMPTZ DEFAULT now(),
  date          DATE DEFAULT CURRENT_DATE
);

-- ── RLS ──
ALTER TABLE sellers       ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance    ENABLE ROW LEVEL SECURITY;
ALTER TABLE shift_handovers ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks         ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "allow_all" ON sellers;
DROP POLICY IF EXISTS "allow_all" ON attendance;
DROP POLICY IF EXISTS "allow_all" ON shift_handovers;
DROP POLICY IF EXISTS "allow_all" ON tasks;

CREATE POLICY "allow_all" ON sellers         FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON attendance      FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON shift_handovers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON tasks           FOR ALL USING (true) WITH CHECK (true);

-- ── Indexes ──
CREATE INDEX IF NOT EXISTS idx_sellers_code       ON sellers(code);
CREATE INDEX IF NOT EXISTS idx_attendance_date    ON attendance(date);
CREATE INDEX IF NOT EXISTS idx_attendance_code    ON attendance(seller_code);
CREATE INDEX IF NOT EXISTS idx_handovers_date     ON shift_handovers(date);
CREATE INDEX IF NOT EXISTS idx_tasks_date         ON tasks(date);
CREATE INDEX IF NOT EXISTS idx_tasks_code         ON tasks(seller_code);

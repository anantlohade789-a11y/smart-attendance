"""
Seed script to populate the database with demo data for Deogiri College
"""
# type: ignore

from app import create_app
from models import db, User, Subject, Session, FamilyEmail
from utils import generate_qr_token, save_qr_code
from datetime import datetime, timedelta
import pytz
import os

def seed_database(force=False):
    """
    Seed the database with demo data for Deogiri College
    """
    app = create_app()
    
    with app.app_context():
        if force:
            print("Force mode: Resetting tables...")
            db.drop_all()
            db.create_all()
        else:
            db.create_all()
        
        print("Ensuring demo accounts exist...")
        
        # Helper to create or update user
        def ensure_user(email, full_name, role, password, student_id=None, phone=None, department=None, year=None):
            user = User.query.filter_by(email=email).first()
            if not user:
                user = User(
                    email=email,
                    full_name=full_name,
                    role=role,
                    student_id=student_id,
                    phone=phone,
                    department=department,
                    year=year,
                    is_active=True
                )
                user.set_password(password)
                db.session.add(user)
                db.session.commit()
                print(f"Created user: {email} ({role})")
            else:
                user.set_password(password)
                user.is_active = True
                db.session.commit()
            return user
        
        # 1. Administrators
        admin1 = ensure_user('admin@deogiri.edu', 'Deogiri College Administrator', 'admin', 'password123', phone='9876543200')
        admin2 = ensure_user('admin@school.test', 'System Administrator', 'admin', 'password123', phone='9876543201')
        
        # 2. Faculty / Teachers
        teacher1 = ensure_user('teacher@deogiri.edu', 'Prof. Rajesh Sharma', 'employee', 'password123', phone='9876543210', department='Computer Science')
        teacher2 = ensure_user('employee@school.test', 'Prof. John Smith', 'employee', 'password123', phone='9876543211', department='Computer Science')
        teacher3 = ensure_user('employee2@school.test', 'Dr. Sarah Johnson', 'employee', 'password123', phone='9876543212', department='Physics')
        
        # 3. Undergraduate Students
        student_anant = ensure_user('student@deogiri.edu', 'Anant Lohade', 'undergraduate', 'password123', student_id='DC2026-001', phone='9876543220', department='Computer Science', year=3)
        student1 = ensure_user('student1@school.test', 'Student 1 (Rahul)', 'undergraduate', 'password123', student_id='STU2025001', phone='9876543221', department='Computer Science', year=3)
        student2 = ensure_user('student2@school.test', 'Student 2 (Priya)', 'undergraduate', 'password123', student_id='STU2025002', phone='9876543222', department='Computer Science', year=3)
        
        for i in range(3, 11):
            ensure_user(f'student{i}@school.test', f'Student {i}', 'undergraduate', 'password123', student_id=f'STU202500{i}' if i < 10 else f'STU20250{i}', department='Computer Science', year=3)
        
        # 4. Postgraduate Students
        pg_student = ensure_user('pgstudent@deogiri.edu', 'Pooja Patil', 'postgraduate', 'password123', student_id='DCPG2026-001', phone='9876543230', department='Computer Science', year=1)
        
        # 5. Family emails
        if FamilyEmail.query.count() == 0:
            db.session.add(FamilyEmail(student_id=student_anant.id, email='family@deogiri.edu', relationship='parent'))
            db.session.add(FamilyEmail(student_id=student1.id, email='parent1@family.test', relationship='mother'))
            db.session.commit()
        
        # 6. Subjects
        if Subject.query.count() == 0:
            subjects = [
                Subject(name='Python Programming & AI', code='CS-301', description='Advanced Python & Machine Learning', teacher_id=teacher1.id),
                Subject(name='Database Management Systems', code='CS-302', description='Relational Databases & SQL', teacher_id=teacher1.id),
                Subject(name='Computer Networks', code='CS-303', description='TCP/IP, OSI Layers and Routing', teacher_id=teacher2.id),
                Subject(name='Data Structures & Algorithms', code='CS-201', description='Arrays, Trees, Graphs & Hashmaps', teacher_id=teacher2.id)
            ]
            for s in subjects:
                db.session.add(s)
            db.session.commit()
            print("Created academic subjects for Deogiri College")
        
        # 7. Sessions
        subjects_list = Subject.query.all()
        if Session.query.count() == 0 and subjects_list:
            now = datetime.now(pytz.UTC)
            today_start = now.replace(hour=9, minute=0, second=0, microsecond=0)
            
            # Default location: Chhatrapati Sambhajinagar (Aurangabad) / Deogiri College campus coords: ~19.8762, 75.3240
            default_lat = 19.8762
            default_lng = 75.3240
            
            # Create an active ongoing session for today!
            session_ongoing = Session(
                subject_id=subjects_list[0].id,
                teacher_id=teacher1.id,
                location_lat=default_lat,
                location_lng=default_lng,
                location_name='Deogiri College - Computer Lab 1',
                start_time=now - timedelta(minutes=15),
                end_time=now + timedelta(hours=2),
                notes='Live lecture session - Ready for QR attendance',
                qr_token='init_token',
                is_active=True
            )
            db.session.add(session_ongoing)
            db.session.flush()
            
            qr_dir = 'static/qr_codes'
            os.makedirs(qr_dir, exist_ok=True)
            token = generate_qr_token(session_ongoing.id, session_ongoing.start_time.isoformat())
            session_ongoing.qr_token = token
            save_qr_code(token, session_ongoing.id, os.path.join(qr_dir, f'session_{session_ongoing.id}.png'))
            
            db.session.commit()
            print("Created active ongoing class session with QR code")
            
        print("\n" + "="*60)
        print("DEOGIRI COLLEGE DEMO ACCOUNTS READY:")
        print("="*60)
        print("  Admin Portal:      /auth/admin")
        print("    Email:           admin@deogiri.edu (or admin@school.test)")
        print("    Password:        password123")
        print("\n  Teacher Portal:    /login/employee")
        print("    Email:           teacher@deogiri.edu (or employee@school.test)")
        print("    Password:        password123")
        print("\n  Student Portal:    /login/undergraduate")
        print("    Email:           student@deogiri.edu (or student1@school.test)")
        print("    Password:        password123")
        print("="*60)

if __name__ == '__main__':
    seed_database()

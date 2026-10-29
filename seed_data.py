"""Seed development accounts and sample classes for local demonstrations."""

from datetime import datetime, timedelta
import os

import pytz

from app import create_app
from models import Attendance, FamilyEmail, Session, Subject, User, db
from utils import generate_qr_token, save_qr_code

ADMIN_EMAIL = 'admin@school.test'
ADMIN_PASSWORD = 'Test1234!'
DEMO_PASSWORD = 'password123'


def seed_database(force=False, app=None):
    """Create sample users and classes without resetting existing passwords."""
    if app is None:
        app = create_app()

    with app.app_context():
        if force:
            print('Force mode: dropping all database tables.')
            db.drop_all()

        db.create_all()

        def ensure_user(email, full_name, role, password, **details):
            user = User.query.filter_by(email=email).first()
            if user is None:
                user = User(
                    email=email,
                    full_name=full_name,
                    role=role,
                    is_active=True,
                    **details,
                )
                user.set_password(password)
                db.session.add(user)
                db.session.commit()
            return user

        admin = ensure_user(
            ADMIN_EMAIL,
            'System Administrator',
            'admin',
            ADMIN_PASSWORD,
        )
        ensure_user(
            'admin@deogiri.edu',
            'Deogiri College Administrator',
            'admin',
            DEMO_PASSWORD,
            phone='9876543200',
        )

        teacher_one = ensure_user(
            'teacher@deogiri.edu',
            'Prof. Rajesh Sharma',
            'employee',
            DEMO_PASSWORD,
            phone='9876543210',
            department='Computer Science',
        )
        teacher_two = ensure_user(
            'employee@school.test',
            'Prof. John Smith',
            'employee',
            DEMO_PASSWORD,
            phone='9876543211',
            department='Computer Science',
        )
        ensure_user(
            'employee2@school.test',
            'Dr. Sarah Johnson',
            'employee',
            DEMO_PASSWORD,
            phone='9876543212',
            department='Physics',
        )

        student = ensure_user(
            'student@deogiri.edu',
            'Anant Lohade',
            'undergraduate',
            DEMO_PASSWORD,
            student_id='DC2026-001',
            phone='9876543220',
            department='Computer Science',
            year=3,
        )
        ensure_user(
            'student1@school.test',
            'Student 1 (Rahul)',
            'undergraduate',
            DEMO_PASSWORD,
            student_id='STU2025001',
            phone='9876543221',
            department='Computer Science',
            year=3,
        )
        ensure_user(
            'student2@school.test',
            'Student 2 (Priya)',
            'undergraduate',
            DEMO_PASSWORD,
            student_id='STU2025002',
            phone='9876543222',
            department='Computer Science',
            year=3,
        )
        for student_number in range(3, 11):
            student_id = (
                f'STU202500{student_number}'
                if student_number < 10
                else f'STU20250{student_number}'
            )
            ensure_user(
                f'student{student_number}@school.test',
                f'Student {student_number}',
                'undergraduate',
                DEMO_PASSWORD,
                student_id=student_id,
                department='Computer Science',
                year=3,
            )
        ensure_user(
            'pgstudent@deogiri.edu',
            'Pooja Patil',
            'postgraduate',
            DEMO_PASSWORD,
            student_id='DCPG2026-001',
            phone='9876543230',
            department='Computer Science',
            year=1,
        )

        if FamilyEmail.query.count() == 0:
            db.session.add_all([
                FamilyEmail(
                    student_id=student.id,
                    email='family@deogiri.edu',
                    relationship='parent',
                ),
            ])
            db.session.commit()

        if Subject.query.count() == 0:
            db.session.add_all([
                Subject(
                    name='Python Programming & AI',
                    code='CS-301',
                    description='Advanced Python & Machine Learning',
                    teacher_id=teacher_one.id,
                ),
                Subject(
                    name='Database Management Systems',
                    code='CS-302',
                    description='Relational Databases & SQL',
                    teacher_id=teacher_one.id,
                ),
                Subject(
                    name='Computer Networks',
                    code='CS-303',
                    description='TCP/IP, OSI Layers and Routing',
                    teacher_id=teacher_two.id,
                ),
                Subject(
                    name='Data Structures & Algorithms',
                    code='CS-201',
                    description='Arrays, Trees, Graphs & Hashmaps',
                    teacher_id=teacher_two.id,
                ),
            ])
            db.session.commit()

        if Session.query.count() == 0:
            subject = Subject.query.order_by(Subject.id).first()
            if subject is not None:
                now = datetime.now(pytz.UTC)
                class_session = Session(
                    subject_id=subject.id,
                    teacher_id=teacher_one.id,
                    location_lat=19.8762,
                    location_lng=75.3240,
                    location_name='Deogiri College - Computer Lab 1',
                    start_time=now - timedelta(minutes=15),
                    end_time=now + timedelta(hours=2),
                    notes='Local demonstration session',
                    qr_token='temporary',
                    is_active=True,
                )
                db.session.add(class_session)
                db.session.flush()
                token = generate_qr_token(
                    class_session.id,
                    class_session.start_time.isoformat(),
                )
                class_session.qr_token = token
                qr_directory = 'static/qr_codes'
                os.makedirs(qr_directory, exist_ok=True)
                save_qr_code(
                    token,
                    class_session.id,
                    os.path.join(qr_directory, f'session_{class_session.id}.png'),
                )
                db.session.commit()

        print(f'Development accounts ready; administrator: {admin.email}')
        print(f'Administrator login: {ADMIN_EMAIL} / {ADMIN_PASSWORD}')
        print('Employee demo login: employee@school.test / ' + DEMO_PASSWORD)
        print('Student demo login: student1@school.test / ' + DEMO_PASSWORD)


if __name__ == '__main__':
    seed_database()

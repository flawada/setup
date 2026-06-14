# example file for now, not self made
import sys
from PySide6.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
    QPushButton, QLabel, QCheckBox, QStackedWidget
)
from PySide6.QtGui import QFont
from subprocess import run


class InstallerWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Application Installer")
        self.setGeometry(100, 100, 600, 500)
        
        # Apply dark theme
        self.apply_dark_theme()
        
        # Create stacked widget for pages
        self.stacked_widget = QStackedWidget()
        self.setCentralWidget(self.stacked_widget)
        
        # Create pages
        self.welcome_page = self.create_welcome_page()
        self.options_page = self.create_options_page()
        self.install_page = self.create_install_page()
        
        # Add pages to stacked widget
        self.stacked_widget.addWidget(self.welcome_page)
        self.stacked_widget.addWidget(self.options_page)
        self.stacked_widget.addWidget(self.install_page)
        
        self.current_page = 0
        self.install_options = {}
        
    def apply_dark_theme(self):
        """Apply a professional dark theme"""
        dark_stylesheet = """
        QMainWindow, QWidget {
            background-color: #1e1e1e;
            color: #ffffff;
        }
        QPushButton {
            background-color: #0d7377;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            padding: 8px 16px;
            font-weight: bold;
            font-size: 11pt;
        }
        QPushButton:hover {
            background-color: #14919b;
        }
        QPushButton:pressed {
            background-color: #0a5460;
        }
        QPushButton:disabled {
            background-color: #404040;
            color: #808080;
        }
        QLabel {
            color: #ffffff;
        }
        QCheckBox {
            color: #ffffff;
            spacing: 8px;
        }
        QCheckBox::indicator {
            width: 18px;
            height: 18px;
        }
        QCheckBox::indicator:unchecked {
            background-color: #404040;
            border: 2px solid #0d7377;
            border-radius: 3px;
        }
        QCheckBox::indicator:checked {
            background-color: #0d7377;
            border: 2px solid #0d7377;
            border-radius: 3px;
        }
        """
        self.setStyleSheet(dark_stylesheet)
    
    def create_welcome_page(self):
        """Create welcome page"""
        widget = QWidget()
        layout = QVBoxLayout()
        layout.setSpacing(20)
        layout.setContentsMargins(40, 40, 40, 40)
        
        # Title
        title = QLabel("Fedora Installer")
        title_font = QFont()
        title_font.setPointSize(18)
        title_font.setBold(True)
        title.setFont(title_font)
        layout.addWidget(title)
        
        # Description
        description = QLabel(
            "Install Nvidia Drivers\n\n"
            "Press Ctrl + H if you dont see your cursor"
        )
        description_font = QFont()
        description_font.setPointSize(11)
        description.setFont(description_font)
        description.setStyleSheet("color: #b0b0b0;")
        layout.addWidget(description)
        
        layout.addStretch()
        
        # Navigation buttons
        button_layout = QHBoxLayout()
        button_layout.addStretch()
        
        next_btn = QPushButton("Next >")
        next_btn.clicked.connect(lambda: self.go_to_page(1))
        button_layout.addWidget(next_btn)
        
        layout.addLayout(button_layout)
        widget.setLayout(layout)
        return widget
    
    def create_options_page(self):
        """Create options selection page"""
        widget = QWidget()
        layout = QVBoxLayout()
        layout.setSpacing(20)
        layout.setContentsMargins(40, 40, 40, 40)
        
        # Title
        title = QLabel("Installation Options")
        title_font = QFont()
        title_font.setPointSize(16)
        title_font.setBold(True)
        title.setFont(title_font)
        layout.addWidget(title)
        
        # Description
        description = QLabel("Select which components you want to install:")
        description_font = QFont()
        description_font.setPointSize(10)
        description.setFont(description_font)
        description.setStyleSheet("color: #b0b0b0;")
        layout.addWidget(description)
        
        # Checkboxes
        self.checkbox_core = QCheckBox("Core Application")
        self.checkbox_core.setChecked(True)
        self.checkbox_core.setFont(QFont("Arial", 11))
        layout.addWidget(self.checkbox_core)
        
        self.checkbox_plugins = QCheckBox("Plugins and Extensions")
        self.checkbox_plugins.setChecked(True)
        self.checkbox_plugins.setFont(QFont("Arial", 11))
        layout.addWidget(self.checkbox_plugins)
        
        self.checkbox_docs = QCheckBox("Documentation")
        self.checkbox_docs.setChecked(False)
        self.checkbox_docs.setFont(QFont("Arial", 11))
        layout.addWidget(self.checkbox_docs)
        
        self.checkbox_examples = QCheckBox("Example Projects")
        self.checkbox_examples.setChecked(False)
        self.checkbox_examples.setFont(QFont("Arial", 11))
        layout.addWidget(self.checkbox_examples)
        
        layout.addStretch()
        
        # Navigation buttons
        button_layout = QHBoxLayout()
        
        back_btn = QPushButton("< Back")
        back_btn.clicked.connect(lambda: self.go_to_page(0))
        button_layout.addWidget(back_btn)
        
        button_layout.addStretch()
        
        next_btn = QPushButton("Next >")
        next_btn.clicked.connect(self.save_options_and_next)
        button_layout.addWidget(next_btn)
        
        layout.addLayout(button_layout)
        widget.setLayout(layout)
        return widget
    
    def create_install_page(self):
        """Create installation page"""
        widget = QWidget()
        layout = QVBoxLayout()
        layout.setSpacing(20)
        layout.setContentsMargins(40, 40, 40, 40)
        
        # Title
        title = QLabel("Ready to Install")
        title_font = QFont()
        title_font.setPointSize(16)
        title_font.setBold(True)
        title.setFont(title_font)
        layout.addWidget(title)
        
        # Description
        description = QLabel("Click 'Install' to proceed with the installation.")
        description_font = QFont()
        description_font.setPointSize(10)
        description.setFont(description_font)
        description.setStyleSheet("color: #b0b0b0;")
        layout.addWidget(description)
        
        layout.addStretch()
        
        # Navigation buttons
        button_layout = QHBoxLayout()
        
        back_btn = QPushButton("< Back")
        back_btn.clicked.connect(lambda: self.go_to_page(1))
        button_layout.addWidget(back_btn)
        
        button_layout.addStretch()
        
        self.install_btn = QPushButton("Install")
        self.install_btn.clicked.connect(self.start_installation)
        button_layout.addWidget(self.install_btn)
        
        layout.addLayout(button_layout)
        widget.setLayout(layout)
        return widget
    
    def save_options_and_next(self):
        """Save selected options and proceed to installation"""
        self.install_options = {
            'core': self.checkbox_core.isChecked(),
            'plugins': self.checkbox_plugins.isChecked(),
            'docs': self.checkbox_docs.isChecked(),
            'examples': self.checkbox_examples.isChecked(),
        }
        self.go_to_page(2)
    
    def start_installation(self):
        """Handle installation"""
        print("Installing with options:", self.install_options)
        run(["pkill","mango"])
        run(["clear"])
        self.close()
    
    def go_to_page(self, page_index):
        """Navigate to a specific page"""
        self.current_page = page_index
        self.stacked_widget.setCurrentIndex(page_index)


def main():
    app = QApplication(sys.argv)
    window = InstallerWindow()
    window.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()

if __name__ == "__main__":
    main()

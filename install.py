
import sys
from PySide6.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, 
                             QPushButton, QLabel, QStatusBar, QMessageBox)
from PySide6.QtGui import QAction, QKeySequence
from PySide6.QtCore import Qt, Slot

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        # 1. Grundeinstellungen des Fensters
        self.setWindowTitle("PySide6 Single File Template")
        self.resize(600, 400)

        # 2. Zentrales Widget & Layout
        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)
        self.layout = QVBoxLayout(self.central_widget)

        # UI-Elemente hinzufügen
        self.label = QLabel("Willkommen in deiner PySide6-App!", alignment=Qt.AlignCenter)
        self.layout.addWidget(self.label)

        self.btn_action = QPushButton("Aktion ausführen")
        self.btn_action.clicked.connect(self.handle_button_click)
        self.layout.addWidget(self.btn_action)

        # 3. Menüleiste erstellen
        self.setup_menu()

        # 4. Statusleiste erstellen
        self.setStatusBar(QStatusBar(self))
        self.statusBar().showMessage("Bereit", 3000) # Nachricht für 3 Sek.

    def setup_menu(self):
        """Erstellt die Menüstruktur der Anwendung."""
        menu_bar = self.menuBar()
        
        # Datei-Menü
        file_menu = menu_bar.addMenu("&Datei")
        
        exit_action = QAction("Beenden", self)
        exit_action.setShortcut(QKeySequence.Quit)
        exit_action.triggered.connect(self.close)
        file_menu.addAction(exit_action)

        # Hilfe-Menü
        help_menu = menu_bar.addMenu("&Hilfe")
        about_action = QAction("Über", self)
        about_action.triggered.connect(self.show_about_dialog)
        help_menu.addAction(about_action)

    @Slot()
    def handle_button_click(self):
        """Slot für den Button-Klick."""
        self.label.setText("Button wurde geklickt!")
        self.statusBar().showMessage("Aktion ausgeführt!", 2000)

    def show_about_dialog(self):
        """Zeigt ein einfaches Info-Fenster."""
        QMessageBox.about(self, "Über diese App", 
                         "Dies ist ein kompaktes PySide6-Template in einer einzelnen Datei.")

if __name__ == "__main__":
    # QApplication Instanz erstellen
    app = QApplication(sys.argv)
    
    # Hauptfenster instanziieren und anzeigen
    window = MainWindow()
    window.show()
    
    # Event-Loop starten
    sys.exit(app.exec())

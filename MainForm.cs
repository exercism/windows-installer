using System;
using System.Windows.Forms;

namespace ExercismWinSetup
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
         
        }

        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            nextButton.Enabled = true;
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
            nextButton.Enabled = false;
        }

        private void nextButton_Click(object sender, EventArgs e)
        {
            Hide();
            InstallLocation installLocationForm = new InstallLocation();
            installLocationForm.StartPosition = FormStartPosition.CenterScreen;
            installLocationForm.ShowDialog();
        }
    }
}

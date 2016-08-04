using System;
using System.Windows.Forms;

namespace ExercismWinSetup
{
    public partial class InstallLocation : Form
    {
        public InstallLocation()
        {
            InitializeComponent();
        }

        private void browseButton_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
            {
                installPath.Text = folderBrowserDialog.SelectedPath;
                downloadNotice.Visible = true;
            }

            
        }

        private void nextButton_Click(object sender, EventArgs e)
        {
            this.Hide();
            ClientDownload clientDownloadForm = new ClientDownload();
        }
    }
}

﻿using System;
using System.IO;
using System.Windows.Forms;

namespace ExercismWinSetup
{
    public partial class InstallLocation : Form
    {
        private string installFolder = "";
        public InstallLocation()
        {
            InitializeComponent();
            installFolder = installPath.Text;
        }

        private void browseButton_Click(object sender, EventArgs e)
        {
            installFolder = installPath.Text;
            if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
            {
                installFolder = folderBrowserDialog.SelectedPath;
                installPath.Text = installFolder;
                downloadNotice.Visible = true;
            }
            if (Directory.Exists(installPath.Text))
            {
                nextButton.Enabled = true;
            }
            else
            {
                nextButton.Enabled = false;
                MessageBox.Show(@"The Installation Path is Not Valid. Please Check Again.");
            }
            
        }

        private void nextButton_Click(object sender, EventArgs e)
        {
            if (!Directory.Exists(installPath.Text))
            {
                Directory.CreateDirectory(@installPath.Text);
            }
            Hide();
            ClientDownload clientDownloadForm = new ClientDownload(installPath.Text);
            clientDownloadForm.StartPosition = FormStartPosition.CenterScreen;
            clientDownloadForm.ShowDialog();
        }

        private void cancelButton_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}

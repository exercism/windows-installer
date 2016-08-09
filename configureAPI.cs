using System;
using System.Diagnostics;
using System.Windows.Forms;

namespace ExercismWinSetup
{
    public partial class ConfigureApi : Form
    {
        private string installPath;
        public ConfigureApi(string installPath)
        {
            this.installPath = installPath;
            InitializeComponent();
        }

        private delegate void ConfigureApiDelegate(string key);

        private void nextButton_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(apiKey.Text))
            {
                MessageBox.Show(
                    @"You have not entered an API key. Please note that Exercism will not work without the API Key");
            }
            ConfigureApiDelegate config = Configure;
            IAsyncResult r = config.BeginInvoke(apiKey.Text, null, null);
            config.EndInvoke(r);
            
            Application.Exit();
        }

        private void Configure(string key)
        {
            Process exercismProcess = new Process();
            exercismProcess.StartInfo.FileName = installPath + @"\exercism.exe";
            
            if (String.IsNullOrEmpty(key))
            {
                exercismProcess.StartInfo.Arguments = " configure --key=" + key;
                exercismProcess.Start();
                exercismProcess.WaitForExit();
            }

            exercismProcess.StartInfo.Arguments = " configure --dir=" + "\"" + installPath + "\"";
            exercismProcess.Start();
            exercismProcess.WaitForExit();

        }
    }
}

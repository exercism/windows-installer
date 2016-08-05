using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Threading;
using System.Windows.Forms;
using Newtonsoft.Json.Linq;

namespace ExercismWinSetup
{
    public partial class ClientDownload : Form
    {
        private static string _installationPath;

        public ClientDownload(string installFolder)
        {
            _installationPath = installFolder;
            InitializeComponent();
            this.Shown += ClientDownload_Shown;
        }

        private void ClientDownload_Shown(object sender, EventArgs e)
        {
            Thread.Sleep(1000);
            bool isGitHubUp = queryGithub();
            if (isGitHubUp)
            {
                HttpWebRequest githubApiRequest = (HttpWebRequest)WebRequest.Create(@"https://api.github.com/repos/exercism/cli/releases/latest");

                githubApiRequest.UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2;)";

                HttpWebResponse githubApiResponse = (HttpWebResponse)githubApiRequest.GetResponse();
                string response = new StreamReader(githubApiResponse.GetResponseStream()).ReadToEnd();

                JObject exercismRelease = JObject.Parse(response);
                JToken downloadUrl;
                if (CheckWindowsArchitecture())
                {
                    downloadUrl = exercismRelease.SelectToken(@"$.assets[?(@.name == 'exercism-windows-64bit.zip')].browser_download_url");
                }
                else
                {
                    downloadUrl = exercismRelease.SelectToken(@"$.assets[?(@.name == 'exercism-windows-32bit.zip')].browser_download_url");
                }

                using (WebClient exercismClientDownload = new WebClient())
                {
                    exercismClientDownload.DownloadFileAsync(new Uri(downloadUrl.ToString()), Path.GetTempPath() + @"\exercism.zip");
                    exercismClientDownload.DownloadFileCompleted += ExercismClientDownload_DownloadFileCompleted;
                }

            }
        }

        private void ExercismClientDownload_DownloadFileCompleted(object sender, System.ComponentModel.AsyncCompletedEventArgs e)
        {
            MessageBox.Show(@"Download Complete");
        }

        private bool queryGithub()
        {
            try
            {
                using (var client = new WebClient())
                {
                    client.Headers.Add("user-agent", @"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2;)");
                    using (var stream = client.OpenRead(@"https://api.github.com"))
                    {
                        return true;
                    }
                }
            }
            catch (Exception)
            {
                return false;
            }
            
        }

        private bool CheckWindowsArchitecture()
        {
            Process systemInfo = new Process
            {
                StartInfo =
                {
                    FileName = "systeminfo.exe",
                    UseShellExecute = false,
                    RedirectStandardOutput = true
                }
            };
            systemInfo.Start();
            var sysInfoOutput = systemInfo.StandardOutput.ReadToEnd();
            if (sysInfoOutput.Contains("x64-"))
            {
                return true;
            }
            return false;
        }

        
    }
}

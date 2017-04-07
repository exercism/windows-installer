using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Net;
using System.Windows.Forms;
using Microsoft.Win32;
using Newtonsoft.Json.Linq;

namespace ExercismWinSetup
{
    public partial class ClientDownload : Form
    {
        private static string _installationPath;
        private static bool _is64bit;

        private delegate bool Install_Delegate(string installPath);

        private delegate bool Check_Windows_Architecture();

        public ClientDownload(string installFolder)
        {
            _installationPath = installFolder;
            InitializeComponent();
            statusTextBox.Text += Environment.NewLine;
            statusTextBox.Text += "Starting Download...";
            Shown += ClientDownload_Shown;
        }

        private void ClientDownload_Shown(object sender, EventArgs e)
        {
            bool isGitHubUp = queryGithub();
            if (File.Exists(Path.GetTempPath() + @"\exercism.zip"))
            {
                File.Delete(Path.GetTempPath() + @"\exercism.zip");
            }
            if (isGitHubUp)
            {
                HttpWebRequest githubApiRequest =
                    (HttpWebRequest) WebRequest.Create(@"https://api.github.com/repos/exercism/cli/releases/latest");

                githubApiRequest.UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2;)";

                HttpWebResponse githubApiResponse = (HttpWebResponse) githubApiRequest.GetResponse();
                string response = new StreamReader(githubApiResponse.GetResponseStream()).ReadToEnd();

                JObject exercismRelease = JObject.Parse(response);
                JToken downloadUrl;
                Check_Windows_Architecture checkArchitecture = CheckWindowsArchitecture;
                IAsyncResult r = checkArchitecture.BeginInvoke(null, null);
                checkArchitecture.EndInvoke(r);
                if (_is64bit)
                {
                    downloadUrl =
                        exercismRelease.SelectToken(
                            @"$.assets[?(@.name == 'exercism-windows-64bit.zip')].browser_download_url");
                }
                else
                {
                    downloadUrl =
                        exercismRelease.SelectToken(
                            @"$.assets[?(@.name == 'exercism-windows-32bit.zip')].browser_download_url");
                }

                using (WebClient exercismClientDownload = new WebClient())
                {
                    exercismClientDownload.DownloadProgressChanged += ExercismClientDownload_DownloadProgressChanged;
                    exercismClientDownload.DownloadFileAsync(new Uri(downloadUrl.ToString()),
                        Path.GetTempPath() + @"\exercism.zip");
                    exercismClientDownload.DownloadFileCompleted += ExercismClientDownload_DownloadFileCompleted;
                }
            }
        }

        private void ExercismClientDownload_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
        {
            installProgressBar.Maximum = (int) e.TotalBytesToReceive/100;
            installProgressBar.Value = (int) e.BytesReceived/100;
        }

        private void ExercismClientDownload_DownloadFileCompleted(object sender,
            AsyncCompletedEventArgs e)
        {
            statusTextBox.Text = statusTextBox.Text + Environment.NewLine + "Download Finished";
            Install_Delegate installDelegate = Install;
            IAsyncResult r = installDelegate.BeginInvoke(_installationPath, null, null);
            installDelegate.EndInvoke(r);
            nextButton.Enabled = true;
            statusTextBox.Text = statusTextBox.Text + Environment.NewLine + "Installation Finished. Click Next.";
        }

        private bool Install(string s)
        {
            try
            {
                if (!Directory.Exists(s))
                {
                    Directory.CreateDirectory(s);
                }
                using (ZipStorer zip = ZipStorer.Open(Path.GetTempPath() + @"\exercism.zip", FileAccess.Read))
                {
                    List<ZipStorer.ZipFileEntry> dir = zip.ReadCentralDir();
                    foreach (ZipStorer.ZipFileEntry entry in dir)
                    {
                        zip.ExtractFile(entry, s + @"\exercism.exe");
                    }
                }

                string pathContent = Environment.GetEnvironmentVariable("PATH") + ";" +_installationPath;
                Environment.SetEnvironmentVariable("PATH", pathContent, EnvironmentVariableTarget.User);

                //string keyName = @"SYSTEM\CurrentControlSet\Control\Session Manager\Environment";
                ////get non-expanded PATH environment variable            
                //var subKey = Registry.LocalMachine.CreateSubKey(keyName);
                //if (subKey != null)
                //{
                //    string oldPath =
                //        (string) subKey.GetValue("Path", "", RegistryValueOptions.DoNotExpandEnvironmentNames);
                //    if (!oldPath.Contains(_installationPath))
                //    {
                //        //set the path as an an expandable string
                //        var registryKey = subKey;
                //        registryKey.SetValue("Path", oldPath + ";" + _installationPath, RegistryValueKind.ExpandString);
                //    }
                //}
                File.Delete(Path.GetTempPath() + @"\exercism.zip");
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        private bool queryGithub()
        {
            try
            {
                using (var client = new WebClient())
                {
                    client.Headers.Add("user-agent", @"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2;)");
                    using (client.OpenRead(@"https://api.github.com"))
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
                _is64bit = true;
                return true;
            }
            _is64bit = false;
            return false;
        }

        private void cancelButton_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void nextButton_Click(object sender, EventArgs e)
        {
            Hide();
            ConfigureApi configureApiForm = new ConfigureApi(_installationPath);
            configureApiForm.StartPosition = FormStartPosition.CenterScreen;
            configureApiForm.ShowDialog();
        }
    }
}

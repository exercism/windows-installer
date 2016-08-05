using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Net;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using ExercismWinSetup.Properties;
using Microsoft.Win32;
using Newtonsoft.Json.Linq;

namespace ExercismWinSetup
{
    public partial class ClientDownload : Form
    {
        private static string _installationPath;

        private delegate bool Install_Delegate(string installPath);

        public ClientDownload(string installFolder)
        {
            _installationPath = installFolder;
            InitializeComponent();
            this.Shown += ClientDownload_Shown;
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
                    exercismClientDownload.DownloadProgressChanged += ExercismClientDownload_DownloadProgressChanged;
                    exercismClientDownload.DownloadFileAsync(new Uri(downloadUrl.ToString()), Path.GetTempPath() + @"\exercism.zip");
                    exercismClientDownload.DownloadFileCompleted += ExercismClientDownload_DownloadFileCompleted;

                }

            }
        }

        private void ExercismClientDownload_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
        {
            installProgressBar.Maximum = (int)e.TotalBytesToReceive / 100;
            installProgressBar.Value = (int)e.BytesReceived / 100;
        }

        private void ExercismClientDownload_DownloadFileCompleted(object sender, System.ComponentModel.AsyncCompletedEventArgs e)
        {
            Install_Delegate installDelegate = null;
            installDelegate = new Install_Delegate(Install);
            IAsyncResult R = null;
            R = installDelegate.BeginInvoke(_installationPath, null, null);
            installDelegate.EndInvoke(R);
            MessageBox.Show("Everything Complete");
        }

        private bool Install(string s)
        {
            try
            {
                s += @"\Exercism";
                if (!Directory.Exists(s))
                {
                    Directory.CreateDirectory(s);
                }
                using (ZipStorer zip = ZipStorer.Open(Path.GetTempPath() + @"\exercism.zip", System.IO.FileAccess.Read))
                {
                    List<ZipStorer.ZipFileEntry> dir = zip.ReadCentralDir();
                    foreach (ZipStorer.ZipFileEntry entry in dir)
                    {
                        zip.ExtractFile(entry, s + @"\exercism.exe");
                    }
                }

                string keyName = @"SYSTEM\CurrentControlSet\Control\Session Manager\Environment";
                //get non-expanded PATH environment variable            
                var subKey = Registry.LocalMachine.CreateSubKey(keyName);
                if (subKey != null)
                {
                    string oldPath = (string)subKey.GetValue("Path", "", RegistryValueOptions.DoNotExpandEnvironmentNames);

                    //set the path as an an expandable string
                    var registryKey = subKey;
                    registryKey.SetValue("Path", oldPath + ";"+_installationPath, RegistryValueKind.ExpandString);
                }

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

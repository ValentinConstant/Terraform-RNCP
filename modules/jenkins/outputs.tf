output "jenkins_url" {
  description = "URL for Jenkins"
  value       = helm_release.jenkins.name
}
